Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7F65358E8
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 07:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbiE0F5A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 01:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbiE0F47 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 01:56:59 -0400
Received: from pv50p00im-tydg10011801.me.com (pv50p00im-tydg10011801.me.com [17.58.6.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFF13467D
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 22:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653631018;
        bh=juBI7kLyX/MUe0t733hEOkq0Czmjv+jG00B0hHXpQ8c=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=xEVTPfmMGgY5Xdcsb5Ni4SeKKEgit6Du8YhujYYI72dFrvXxvnMFvDWAc3z26M7WD
         LLL4py/mvmL1uCLozb3stNHWAxwyKsPsHLPFZzn6olliNgVSClRf2zD8dJLeL2W5nZ
         MY5XAE6LvRDybE3Y0Ci8GUG25/QUnAgXa3ayQg/xRvTRy2ZYtMBLTWnKwRsylUDWgp
         n5DViE3seQV/Snj1eLvvssMnygknmB5BJ8ZmV4rZ3+l9qb1/xAPwO1Acu/eWo7HEY3
         EuK9LzShUV/R2dCLhNK4lyGO9MQ2GGVBWZUPCUOCmLFR9+a12Ux2p/j1vq1+v1vLEz
         lkFR8Bty/ZV9A==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10011801.me.com (Postfix) with ESMTPSA id 227B38003C0;
        Fri, 27 May 2022 05:56:56 +0000 (UTC)
Message-ID: <a994fa74-0aec-d345-7375-8388368d1354@icloud.com>
Date:   Fri, 27 May 2022 13:56:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: wire up allocated direct descriptors for socket
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <fdf98193-26d2-b543-acac-82e9557d3072@kernel.dk>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <fdf98193-26d2-b543-acac-82e9557d3072@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-27_01:2022-05-25,2022-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205270029
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/22 07:05, Jens Axboe wrote:
> The socket support was merged in an earlier branch that didn't yet
> have support for allocating direct descriptors, hence only open
> and accept got support for that.
> 
> Do the one-liner to enable it now, so we have consistent support for
> any request that can instantiate a file/direct descriptor.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ccb47d87a65a..d50bbf8de4fb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6676,8 +6676,8 @@ static int io_socket(struct io_kiocb *req, unsigned int issue_flags)
>   		fd_install(fd, file);
>   		ret = fd;
>   	} else {
> -		ret = io_install_fixed_file(req, file, issue_flags,
> -					    sock->file_slot - 1);
> +		ret = io_fixed_fd_install(req, issue_flags, file,
> +					    sock->file_slot);
>   	}
>   	__io_req_complete(req, issue_flags, ret, 0);
>   	return 0;
> 


Reviewed-by: Hao Xu <howeyxu@tencent.com>
