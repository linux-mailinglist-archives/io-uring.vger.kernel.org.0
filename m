Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5811C2EEB25
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 02:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbhAHB6Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 20:58:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55840 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbhAHB6Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 20:58:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081tTaG152564;
        Fri, 8 Jan 2021 01:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=4cncn4rSq4SFBlO0K/yF0pzWeYVy7g2r+J3O7hRw26M=;
 b=jrPnb5CUC4IOH/DVj1CizERliHtrZ0Ivb/zCzxW5QdZIgSzZOjRqH4lkoFCNMnX0B+oK
 CTTZuWZeOU44bs+47av/HAr66hnrggGOBgz3YhPsom4yfpMd/oJqt/JBM+LcrlLZRsQi
 HEQL7rkrFY8cRBZD3kVgJ22iWAdLezYMv2u3jxNBW7CJ0TN2vZbx/2FHZrXBreRmXzfR
 n6QVQXPqVSYuV7fG178M8y9STBNTfalu+zu3wfLuJ27Oq9L3b1wj20ATS5/MnFmyDZXw
 uxrNyzmOJ/gIGe/zqa531YoYwTSaVsF51BKOYefQsniVtRQ/LBI+n/Fkc/Otfnj2ui8T Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35wcuxyhk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 01:57:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081susA134350;
        Fri, 8 Jan 2021 01:57:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1fbykrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 01:57:41 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1081vfWk018058;
        Fri, 8 Jan 2021 01:57:41 GMT
Received: from [10.154.113.215] (/10.154.113.215)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 01:57:41 +0000
Subject: Re: [PATCH v4 09/13] io_uring: create common fixed_rsrc_ref_node
 handling routines
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1609965562-13569-10-git-send-email-bijan.mottahedeh@oracle.com>
Message-ID: <78271e99-04e8-d59c-10ad-6e95112ee4e9@oracle.com>
Date:   Thu, 7 Jan 2021 17:57:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1609965562-13569-10-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080007
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/6/2021 12:39 PM, Bijan Mottahedeh wrote:
> Create common routines to be used for both files/buffers registration.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>   fs/io_uring.c | 47 ++++++++++++++++++++++++-----------------------
>   1 file changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 91be618..fbff8480 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7303,15 +7303,12 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
>   	percpu_ref_get(&rsrc_data->refs);
>   }
>   
> -static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
> +static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
> +			       struct io_ring_ctx *ctx)
>   {
> -	struct fixed_rsrc_data *data = ctx->file_data;
>   	struct fixed_rsrc_ref_node *backup_node, *ref_node = NULL;
> -	unsigned nr_tables, i;
>   	int ret;
>   
> -	if (!data)
> -		return -ENXIO;
>   	backup_node = alloc_fixed_file_ref_node(ctx);
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I introduced a bug here; I call the file allocator directly.  I've fixed 
it by passing in the proper allocator.  Will send it with the next patch 
set.


>   	if (!backup_node)
>   		return -ENOMEM;
> @@ -7339,6 +7336,23 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>   		}
>   	} while (1);
>   
> +	destroy_fixed_rsrc_ref_node(backup_node);
> +	return 0;
> +}
> +
> +static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
> +{
> +	struct fixed_rsrc_data *data = ctx->file_data;
> +	unsigned int nr_tables, i;
> +	int ret;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	ret = io_rsrc_ref_quiesce(data, ctx);
> +	if (ret)
> +		return ret;
> +
>   	__io_sqe_files_unregister(ctx);
>   	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
>   	for (i = 0; i < nr_tables; i++)
> @@ -7348,7 +7362,6 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>   	kfree(data);
>   	ctx->file_data = NULL;
>   	ctx->nr_user_files = 0;
> -	destroy_fixed_rsrc_ref_node(backup_node);
>   	return 0;
>   }
>   
> @@ -8384,22 +8397,14 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
>   static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>   {
>   	struct fixed_rsrc_data *data = ctx->buf_data;
> -	struct fixed_rsrc_ref_node *ref_node = NULL;
> +	int ret;
>   
>   	if (!data)
>   		return -ENXIO;
>   
> -	io_rsrc_ref_lock(ctx);
> -	ref_node = data->node;
> -	io_rsrc_ref_unlock(ctx);
> -	if (ref_node)
> -		percpu_ref_kill(&ref_node->refs);
> -
> -	percpu_ref_kill(&data->refs);
> -
> -	/* wait for all refs nodes to complete */
> -	flush_delayed_work(&ctx->rsrc_put_work);
> -	wait_for_completion(&data->done);
> +	ret = io_rsrc_ref_quiesce(data, ctx);
> +	if (ret)
> +		return ret;
>   
>   	io_buffers_unmap(ctx);
>   	io_buffers_map_free(ctx);
> @@ -8751,11 +8756,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>   		return PTR_ERR(ref_node);
>   	}
>   
> -	buf_data->node = ref_node;
> -	io_rsrc_ref_lock(ctx);
> -	list_add(&ref_node->node, &ctx->rsrc_ref_list);
> -	io_rsrc_ref_unlock(ctx);
> -	percpu_ref_get(&buf_data->refs);
> +	io_sqe_rsrc_set_node(ctx, buf_data, ref_node);
>   	return 0;
>   }
>   
> 

