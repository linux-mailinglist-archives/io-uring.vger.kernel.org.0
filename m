Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207BE505EFC
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 22:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347820AbiDRUxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 16:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiDRUxe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 16:53:34 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D54722BD7
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 13:50:53 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p62so3012327iod.0
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 13:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=t2H5LrFdRSniBP7BYPjftYKAlUXRf2wE+LsqyEhX938=;
        b=yTIgefqqkz9mSPxx64xvXab8jwdzdbKWL4qd9e7CJ4nBmzVplMf5DH1U6naSIvjDVP
         WxcyP7Rc9nI+XMY/TAT/aVwG1WvAUMW3KeOI3BhA5wgX2Mi9N+NH9USs2/AvudKUthzL
         cDp2GZxp0eAJL8bwYEZ+YNFELt4VmPsPwigz6akSw9uJgdBY6P6knsaazqX1JTaStmJf
         aZaO8usIlGwMs/MKvpiX0lljmLtZAqVNGts6c/+jJo9GQPfGOHy/nxEJ7tJSCd/WqxR/
         E0yYxZ1cXGrEWIG1acDRCftRLPY4szIZtHjkyUtV1LOnFX3R2uFhNVF7SYgYUwKPkt6o
         FL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t2H5LrFdRSniBP7BYPjftYKAlUXRf2wE+LsqyEhX938=;
        b=7YPmn4sRGksPlsmx4PjQFvOTXSJruFR1W2weWACCrCvoa9eqC84xniB3FTsMSMOToP
         CvLuFP30rJSO242y+R80pQXOFWnvs6PvxH7Lq+Q937Ekc/SBCJ/JmxgN5hnEMMCTwmC6
         RHVGoIm71B4+dWG1X2xXUAF9KxpxLXp3XEviq+jeh0vocG7k9X1tBwwyql0NtCWMIlRk
         mpigQtvMd6BmFA/vNXZMX7gW7m14h+KbBsWP5PRlHEGSrMOERXNZs0x2u6uoTJvoAAZZ
         QGmDtYWo3yLEVWF5lG/HWPCXXWnli1catJLFERbBe4xivPUV12T0z+0IAHp+askYpjjr
         Q4Kg==
X-Gm-Message-State: AOAM530gLl6n+TLAxrCQiaxvGa7tUSTcTctOJSPUyDQxNpvuab6a5Pjb
        fzkEINSo3ihwXIz8hi2yEjVjrXkmayw5oQ==
X-Google-Smtp-Source: ABdhPJxy7HSQxH0LTSpRFyB/vST60xPCCKV7ysTHod1GvVcFVdE/ZLhPieILLeVydaVN+UM1VrQSXA==
X-Received: by 2002:a6b:ed06:0:b0:649:d35f:852c with SMTP id n6-20020a6bed06000000b00649d35f852cmr5419350iog.186.1650315052872;
        Mon, 18 Apr 2022 13:50:52 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x186-20020a6bc7c3000000b00648deae6630sm9063572iof.54.2022.04.18.13.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 13:50:52 -0700 (PDT)
Message-ID: <edbfa8e8-c3a0-aa58-81ab-09e3841101f3@kernel.dk>
Date:   Mon, 18 Apr 2022 14:50:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/5] io_uring: refactor io_assign_file error path
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1650311386.git.asml.silence@gmail.com>
 <eff77fb1eac2b6a90cca5223813e6a396ffedec0.1650311386.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <eff77fb1eac2b6a90cca5223813e6a396ffedec0.1650311386.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/22 1:51 PM, Pavel Begunkov wrote:
> All io_assign_file() callers do error handling themselves,
> req_set_fail() in the io_assign_file()'s fail path needlessly bloats the
> kernel and is not the best abstraction to have. Simplify the error path.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 423427e2203f..9626bc1cb0a0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7117,12 +7117,8 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
>  		req->file = io_file_get_fixed(req, req->cqe.fd, issue_flags);
>  	else
>  		req->file = io_file_get_normal(req, req->cqe.fd);
> -	if (req->file)
> -		return true;
>  
> -	req_set_fail(req);
> -	req->cqe.res = -EBADF;
> -	return false;
> +	return !!req->file;

Wouldn't it be cleaner to just do:


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7625b29153b9..b91bcd52cc95 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7098,15 +7098,8 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 		return true;
 
 	if (req->flags & REQ_F_FIXED_FILE)
-		req->file = io_file_get_fixed(req, req->fd, issue_flags);
-	else
-		req->file = io_file_get_normal(req, req->fd);
-	if (req->file)
-		return true;
-
-	req_set_fail(req);
-	req->result = -EBADF;
-	return false;
+		return io_file_get_fixed(req, req->fd, issue_flags);
+	return io_file_get_normal(req, req->fd);
 }
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)

-- 
Jens Axboe

