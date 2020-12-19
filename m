Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BDB2DEFD5
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 14:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgLSN1z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 08:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgLSN1z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 08:27:55 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB961C0617B0
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 05:27:14 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id h186so3293503pfe.0
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 05:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X0CmRjBq596vb807//GKT4AopKraqebi4ZJG8MFWUQg=;
        b=fHFNEe277TpiXRjqacoyWzVqKTe8tg+w5DmlW4oy7AB4KYoD3ElxXLTgLefeQRmoEJ
         7NqoWSH/LNlUKIoW0TAsdJOvPKeHYy+rjfOJ6VEExk97N2SgOL5xk+ehzGpTuO3S5wtV
         TAIcMD4V8Bdh6CKruDuW+l0Tl3/qe8upG9SrmstOeh2cRO6YjioPwscmzjMGk55b6n/+
         Sk7ir2XfQCu93g/wX3QhtgPE6GhsCgQkKHRrKBgx5zuMGJFhnO1qIZvQgP/mBt488EXU
         pAJzoJGUaly6aS7EiIGEX0hX1nfAQHem8ZVzIA5AjiG8YHQyFGLDcmIitsQD3mQiA6Ql
         2J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X0CmRjBq596vb807//GKT4AopKraqebi4ZJG8MFWUQg=;
        b=VxoTGsootMnX2s3bxQUbHp2Pxe5c7/kUTJJNV7GrlUbQYhQLL1eJd5mDrwIGZ19N7+
         Y/qA2YQ4kKQFwDfmIQB4sIyQzee2UZlpX9OzXc7qHiVlMfoIzIcQ6bSi9JD29g5ePzeb
         H4aAdrG/AhmKIa4hRrtB8d2HURIXCNrTQ6XV8gFsiFkX481zx7c2UalWSvAlU7sUu7YD
         Qk92YqoRStzjZ+ZVM/Gq7gikgpjWFlvKTI2RhmU6kY9mz7Nis+KptouPmHiKVx7gHgez
         aRb2WoRXTqSm3S8SwEyN+BUWNLhkZ0u/s7E3BPvd5dt8yWvIkcafRMIFf3pv8xiqmXW1
         F4iA==
X-Gm-Message-State: AOAM531hrm+tXCNYxugE/BNnKILxgllBCnHCGjfF/VUmsUdtZfUbZ3p5
        Gxvx8uWKnXW0F0918WXPpVKEHQ==
X-Google-Smtp-Source: ABdhPJzOXwFyRRBMfWXWuzVm1UR6H7Km/t0285AaQGLY76o1kVySy8YkW8MvvhAII2vK77OI5ZZWoQ==
X-Received: by 2002:a63:5351:: with SMTP id t17mr8143895pgl.176.1608384434319;
        Sat, 19 Dec 2020 05:27:14 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v9sm11374511pff.102.2020.12.19.05.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 05:27:13 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix 0-iov read buffer select
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cdc2fad4b752b14b6be240a3cd9e5a342271625a.1608347693.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15a8aac0-99c5-316b-1f12-0991b3c863b3@kernel.dk>
Date:   Sat, 19 Dec 2020 06:27:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cdc2fad4b752b14b6be240a3cd9e5a342271625a.1608347693.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/20 8:15 PM, Pavel Begunkov wrote:
> Doing vectored buf-select read with 0 iovec passed is meaningless and
> utterly broken, forbid it.

Applied, thanks.

-- 
Jens Axboe

