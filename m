Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E38C2D16A7
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 17:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgLGQnE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 11:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbgLGQnD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 11:43:03 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31EAC061794
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 08:42:23 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id t9so8441790ilf.2
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 08:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WUXdGrh7XO4kGUnhKynr9yMqAyjGgxLuT4au2qV1y0o=;
        b=HCc5USXWzf1C8eAf6bK1vTReDwNU/PDo6KYuEe6K9D5V9nbjxeIucg7fsfdhoYBtr4
         y7RNvjKs1rlcfVIC/Q9TedCnAbveMdTeqvyWLBOFZq1jOiwJFFm1tUKsiD8QOHWtEZ5z
         tgvIDlaTMZXMBtjSkgjUcOlW7QucUcTONVY9bQEZPvked4zD8qSgFpTje8ugvjlvr++d
         ob63I9kqBOQms/k3+Z9pNE3aGlm86cwG5UMLIDWtzH+a0GkG7kqLTzY/9PnQAHp971+N
         Mh6h4Z1qjfzPV16KgSUoCwpf5ug7B9issBMhwsrL8bBpigWZmADUr2PT/BQMhFMxAHHp
         7CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WUXdGrh7XO4kGUnhKynr9yMqAyjGgxLuT4au2qV1y0o=;
        b=nIEm4Cy8kU4yx+dcYgxWq5Lt1m0ZBCNwWA7fSmwe5Ij2oZf6vClJNj5gtzsrWzEuux
         s/bgaae31LxlCqvmHDf48LtQPHkfruhe/D+GT+mnLKalPsJuCnMEUpBbaITk5HBH6Q7p
         a+frRSjKJQuBf9UEdMjhueQ4+kXtAKYTKNGH6qSVuxxUfq3X0p7424vVdWP03T34qSxB
         0xM7naZ8i+w1Msf+FkQRTrINvU34hnMiFpnKZNtmWSRvDIbj6rul46npI7EoupnPTBF1
         DAqYPOr6YPTp9hBZPxkJPIxLV4mdmSzhuPnx7W8lqq6ArlWnYQ6ewtSA5w65PKorcP6j
         T5cw==
X-Gm-Message-State: AOAM531BCWHel9Ra3T/VO+caXINPUi+dxTkY3u3761Y95ohR/ZxyD9ko
        iGJ1rFW8l3osXYshfG3/GWE4cw==
X-Google-Smtp-Source: ABdhPJxQ5FNWrRgSa7NB4MPkDzICtRsqAtY2CqKv4oHrMtAQtfJJzkwjvk9c02nQmMaUSqjdzk1yOw==
X-Received: by 2002:a92:cccb:: with SMTP id u11mr21724011ilq.44.1607359342776;
        Mon, 07 Dec 2020 08:42:22 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a3sm7493167ilp.5.2020.12.07.08.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 08:42:22 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix file leak on creating io ctx
To:     Hillf Danton <hdanton@sina.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+71c4697e27c99fddcf17@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20201207081558.2361-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3466437a-0325-1cb8-6aa9-594527382390@kernel.dk>
Date:   Mon, 7 Dec 2020 09:42:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207081558.2361-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/20 1:15 AM, Hillf Danton wrote:
> @@ -9207,12 +9208,14 @@ err_fd:
>  #if defined(CONFIG_UNIX)
>  	ctx->ring_sock->file = file;
>  #endif
> -	if (unlikely(io_uring_add_task_file(ctx, file))) {
> -		file = ERR_PTR(-ENOMEM);
> -		goto err_fd;
> +	ret = io_uring_add_task_file(ctx, file);
> +	if (ret) {
> +		fput(file);
> +		put_unused_fd(fd);
> +		goto err;
>  	}
>  	fd_install(ret, file);
> -	return ret;
> +	return 0;

You're installing the return value from io_uring_add_task_file() in the
fd table, and then returning '0' for the fd...

-- 
Jens Axboe

