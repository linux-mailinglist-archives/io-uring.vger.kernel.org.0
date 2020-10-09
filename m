Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0974287FCA
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 03:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgJIBJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 21:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgJIBJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 21:09:46 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4D1C0613D4
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 18:09:44 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id b193so4908154pga.6
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 18:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xVtaazHLap0AOGbhNnd3svkYUCPJJww/W0XS3nSiO+8=;
        b=nbww3YdNEubpRBuP77GrOtqtpaNcCVF1sBRT/DemJ9upzP2NEPwxnfX4P7aq51Yckv
         PpvkynNQZetIrV2l7mvwlppEm5vcY7BOFODRFm3xMAuHE7aE7D+VAyupKzEaIdGvkKVe
         VbuZC4z3kLeu9S71zb7RvUtcJwo1qLl90Br5t7hjRW8rct62xrLiHFthWhcqW/k/3Hf7
         DrLbz2jpVbyUN3RgDBA/0PN3jefNXg/qmLMEPg9LXTaGQssns/Q7xOG0nGP5ZHJfi9W9
         7S6v4zys7kI9mekUbJyhzXR5NfAC8lzEM2S+DAvDKOPoSHwxDsZpqeeQQiLvhsuG9siX
         Auwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xVtaazHLap0AOGbhNnd3svkYUCPJJww/W0XS3nSiO+8=;
        b=QuC/EIkZCo+P7zyebXg7gaMeHFsdAkVeeffUzM4vjl/8unQD+lkwRGBulnWMycUd0t
         +Q0Tilhmf4cglGR+rZCjZ7gYEhHFzlb41vzpF/3EFqma8dbK0AcEi8CV9y2NliJ/In5S
         VBBIwOIgYQbXvoNlN3BRrOsKVfdIINaxW3ODj6UYsUuH3jIurxXq7xRPgoFpO8ptX6vu
         +9xphjQgXZ1F+IANQD4QwoqkxarkmcGyNtmWbC6giInRNlMjIAt0W77oECOSlEKc04Pt
         qb3VEgMYfo3npZ6QWiGvMcF+8KpLIg7vVELvW6PLtdeiANm7Ep3pta54QF36iDO58D3L
         jxbg==
X-Gm-Message-State: AOAM533zhWu4vPQoCt/iAtLLPn5fBSmhSb0m+zS8DnMVP3e2Gf4y9vkV
        6DehlpXL5x7tvG2UEpTD/TuW+w==
X-Google-Smtp-Source: ABdhPJywAib2tPyDFzjfzXQKUguHRN7peDDzdodPUGsMT4cGw3W1ThU3Wu2Dy09pW/3+4oyv8TaIyA==
X-Received: by 2002:a17:90a:3804:: with SMTP id w4mr1710860pjb.171.1602205784152;
        Thu, 08 Oct 2020 18:09:44 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l82sm3984061pfd.102.2020.10.08.18.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 18:09:43 -0700 (PDT)
Subject: Re: io_uring: process task work in io_uring_register()
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f7ac4874-9c6c-4f41-653b-b5a664bfc843@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <781195af-9d58-202f-0451-b36c1705fdc1@kernel.dk>
Date:   Thu, 8 Oct 2020 19:09:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f7ac4874-9c6c-4f41-653b-b5a664bfc843@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 12:23 PM, Colin Ian King wrote:
> Hi,
> 
> Static analysis with Coverity has detected a "dead-code" issue with the
> following commit:
> 
> commit af9c1a44f8dee7a958e07977f24ba40e3c770987
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Sep 24 13:32:18 2020 -0600
> 
>     io_uring: process task work in io_uring_register()
> 
> The analysis is as follows:
> 
> 9513                do {
> 9514                        ret =
> wait_for_completion_interruptible(&ctx->ref_comp);
> 
> cond_const: Condition ret, taking false branch. Now the value of ret is
> equal to 0.
> 
> 9515                        if (!ret)
> 9516                                break;
> 9517                        if (io_run_task_work_sig() > 0)
> 9518                                continue;
> 9519                } while (1);
> 9520
> 9521                mutex_lock(&ctx->uring_lock);
> 9522
> 
> const: At condition ret, the value of ret must be equal to 0.
> dead_error_condition: The condition ret cannot be true.

Thanks, yeah that condition is reversed, should be:


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4df5b14c2e56..80a0aa33db49 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9511,8 +9511,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			ret = wait_for_completion_interruptible(&ctx->ref_comp);
 			if (!ret)
 				break;
-			if (io_run_task_work_sig() > 0)
-				continue;
+			if (io_run_task_work_sig() <= 0)
+				break;
 		} while (1);
 
 		mutex_lock(&ctx->uring_lock);

-- 
Jens Axboe

