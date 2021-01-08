Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC932EEB21
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 02:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbhAHBxq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 20:53:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52576 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729850AbhAHBxp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 20:53:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081n2Q2126983;
        Fri, 8 Jan 2021 01:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zGlt2YuUYWNYY92n6vTEm4mhu0Apm8vIaPqgpris+uE=;
 b=DUMq6ovy+Tq3jPxauZSXZ7pV/sK7nyiVaxXv3qRZMdiM8AQSLdbQFzFu3lHDtcHiM0Sm
 G1ADvi4ARS7mNvAwWPa/+5M5rMP5omALtd8z+/so51zFRqzduo+BcQ3f6GU+VFl/CPjQ
 PnD5H1RYwBAEjHGZ9dHgxsBBXaVd7aoPWOHAMTagnWJ9e2PZL+zbkfpD2wSNTvvrbgDv
 FAtt+vEVT9HxfxoAoOjfC+c+Lb6wUbIc8LZqatsqfJjTA6/E1fnHbAvkeI9trbWA+/JI
 IU96Qf/rSfC54t/GHKgTAA0cFG4jFn4Kl+05VjoHOJH4V17JY/z/2BPfKa96Nk7+BNsZ OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuxyhdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 01:53:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081kUND081734;
        Fri, 8 Jan 2021 01:53:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35w3qumqfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 01:53:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1081r14s016267;
        Fri, 8 Jan 2021 01:53:01 GMT
Received: from [10.154.113.215] (/10.154.113.215)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 01:53:00 +0000
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
 <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
 <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
 <66fd0092-2d03-02c0-fe1c-941c761a24f8@gmail.com>
 <20b6a902-4193-22fe-2cd7-569024648a26@oracle.com>
 <5d14a511-34d2-1aa7-e902-ed4f0e6ded82@gmail.com>
 <554b54ec-f7b4-a8ed-6b74-8d209b0a0f5f@oracle.com>
 <d673405c-79bb-d326-13cf-c54ad3f36b4b@gmail.com>
 <e7e1365b-5392-5d58-959f-0cbfc0c74fef@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <f1288c74-fbab-b02e-f3b4-f96953a7572d@oracle.com>
Date:   Thu, 7 Jan 2021 17:53:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e7e1365b-5392-5d58-959f-0cbfc0c74fef@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080006
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> Forgot to mention, I failed to find where you do
> io_set_resource_node() in v4 for fixed reads/writes.
> Also, it should be done during submission, io_prep_rw()
> is the right place for that.

Would something like below be ok?  I renamed io_set_resource_node() to 
io_get_fixed_rsrc_ref() to make its function more clear and also 
distinguish it from io_sqe_rsrc_set_node().



diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd55d11..a9b9881 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1083,12 +1083,11 @@ static inline void io_clean_op(struct io_kiocb *req)
                 __io_clean_op(req);
  }

-static inline void io_set_resource_node(struct io_kiocb *req)
+static inline void io_get_fixed_rsrc_ref(struct io_kiocb *req,
+                                        struct fixed_rsrc_data *rsrc_data)
  {
-       struct io_ring_ctx *ctx = req->ctx;
-
         if (!req->fixed_rsrc_refs) {
-               req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+               req->fixed_rsrc_refs = &rsrc_data->node->refs;
                 percpu_ref_get(req->fixed_rsrc_refs);
         }
  }
@@ -2928,6 +2927,9 @@ static int io_prep_rw(struct io_kiocb *req, const 
struct i
         req->rw.addr = READ_ONCE(sqe->addr);
         req->rw.len = READ_ONCE(sqe->len);
         req->buf_index = READ_ONCE(sqe->buf_index);
+       if (req->opcode == IORING_OP_READ_FIXED ||
+           req->opcode == IORING_OP_WRITE_FIXED)
+               io_get_fixed_rsrc_ref(req, ctx->buf_data);
         return 0;
  }

@@ -6452,7 +6454,7 @@ static struct file *io_file_get(struct 
io_submit_state *st
                         return NULL;
                 fd = array_index_nospec(fd, ctx->nr_user_files);
                 file = io_file_from_index(ctx, fd);
-               io_set_resource_node(req);
+               io_get_fixed_rsrc_ref(req, ctx->file_data);
         } else {
                 trace_io_uring_file_get(ctx, fd);
                 file = __io_file_get(state, fd);

