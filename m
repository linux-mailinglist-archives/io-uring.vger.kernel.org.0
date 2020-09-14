Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C51268FD2
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 17:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgINP1k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 11:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgINP1T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 11:27:19 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0BEC06174A
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 08:27:18 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q4so4102538ils.4
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 08:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KSgdYHWdyQE2DZIRIMQjAN7eUlp05ySgkkWzGXUXs9Y=;
        b=a4YVnjHYn3oQzhU5/2d04f5P4nzzbv35irUCHc1ie5Y6BmhpHHjNGdI2UHER+c37t3
         ALcoSMzBrO1M7CoFQZOhYJhbaTD73t2F3fZZrdPi1UtUYBRt9vHKTOC6xY6VBDE+e++p
         iHs6qZEfppQ4eHl+RvFo5ASlAHCjYLM1370Ee7YVWHyIda7Utt0SPLpxm6P+7KRwv0yx
         J1yUQp5u5Vx/45QQ5qmWBiM8LyCnP5O8Xc7Jk6eIARCLJKqW17OOWacSK+BDM/TgnQsF
         4RPv4FAsxxgn5BrLH33ojEeKFTQ/GZzut/eESuo+DeQ/bfhra3FfgI/L32P8grQIMVlY
         gcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KSgdYHWdyQE2DZIRIMQjAN7eUlp05ySgkkWzGXUXs9Y=;
        b=ELImQUBoSegs9IfNr6/vyDCntl+Ng6n30Kmn/xsAXwFppmTI4uW4cbRhYvrSYE9kri
         cqzEztBrtHyLxKgRKdtLI4ldmeEScz749p4/S13RqeXttHaqI/XBBCUlLfGhKIKVpse9
         ZjqSkMe1WqZ2Tx+aOdgFJ7oLy1Wf9IWNFG1NpbNVlPF220WsyCm5mueXQfH0vPLyFQzk
         xc3BO9P3Ws2E3/+fA9AX5XPTrbM/D4j3W0tG+loYgwMClowPc4WKAEgqySj9c/VMb11J
         2RYmALaOOuk5vpLR3U7ty/O8xoiqwT11YRHKkxxzz4F4zdSzJwZs0KqJA51dC7owUy7u
         JaZA==
X-Gm-Message-State: AOAM533Ke7KZ2NnGBI72htCWoLno4ENLMeN7m74uNZxjMt6NiZxZBUUV
        kBoqtZVBwpP7guzfpZM1YaOmwUlDPzQtkKV9
X-Google-Smtp-Source: ABdhPJwMg4pFd0P7J8rawWcKACtiCqP1kiW2/6sQyM4LzO/8dngN7qRFh8Lcd1lv8iRSDBff5qvf1A==
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr12619460ilq.287.1600097237197;
        Mon, 14 Sep 2020 08:27:17 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u9sm5819067iow.26.2020.09.14.08.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 08:27:16 -0700 (PDT)
Subject: Re: IO_URING on XFS regression bug report
To:     Zorro Lang <zlang@redhat.com>, io-uring@vger.kernel.org
References: <20200914074559.GM2937@dhcp-12-102.nay.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9d3c38bc-302c-5eb6-c772-7072a75eaf74@kernel.dk>
Date:   Mon, 14 Sep 2020 09:27:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200914074559.GM2937@dhcp-12-102.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/20 1:45 AM, Zorro Lang wrote:
> Hi,
> 
> Due to I don't know how to report a bug to io_uring maillist, I didn't find a
> proper bug component for io_uring. So I have to send this email directly to
> report this bug:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=209243
> 
> Due to it's reproducible on XFS+LVM, but the first failed commit is an io_uring
> patch:
> 
>   bcf5a06304d6 ("io_uring: support true async buffered reads, if file provides it")
> 
> So I'm not sure if it's an io_uring bug or xfs bug, so report to io_uring@ list to
> help to analyze this failure.

Can you try with the below?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 892a8dcf92c7..6c6aa37031d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2293,13 +2293,17 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 		goto end_req;
 	}
 
-	ret = io_import_iovec(rw, req, &iovec, &iter, false);
-	if (ret < 0)
-		goto end_req;
-	ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-	if (!ret)
+	if (!req->io) {
+		ret = io_import_iovec(rw, req, &iovec, &iter, false);
+		if (ret < 0)
+			goto end_req;
+		ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
+		if (!ret)
+			return true;
+		kfree(iovec);
+	} else {
 		return true;
-	kfree(iovec);
+	}
 end_req:
 	req_set_fail_links(req);
 	io_req_complete(req, ret);
@@ -3096,6 +3100,13 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
+	/*
+	 * If we can't do nonblock submit without -EAGAIN direct return,
+	 * then don't use the retry based approach.
+	 */
+	if (!io_file_supports_async(req->file, READ))
+		return false;
+
 	wait->wait.func = io_async_buf_func;
 	wait->wait.private = req;
 	wait->wait.flags = 0;

-- 
Jens Axboe

