Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5468D1FBF5E
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 21:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgFPTrj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 15:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730609AbgFPTri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 15:47:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDEFC061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:47:38 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id v14so47020pgl.1
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=806JURq/BJWrkgeS4g+rrDd0b7ErtjaFevr3VNAOPgc=;
        b=q2mrhEMaG69/juTcLRED+EDNRyCgRNCpERKOYYgyDMT+OTe+aML+cFniLcBopiUA57
         gsfwn64Rlqfj2A/Nw23WM6IU9vZN5ndsaVrQIM/uihQK91AAoX1N0KxLY2xplW3LZ44E
         382xI0787aVNosKa2UcA6K0orgRC656Av8DHddL/s+CNGTYKfMgQcEcDWE2R62lQLh2Z
         ODG2JBhQJUdABNEJ7GHf2fxNLHxgTO+DpmDnCsFJe/udSGdzItJrigN3VGey6kG6l9Wj
         jgvJ3mBHK6/1eLk0j353i6V6BjrhLW4UKZM5/uieIkghR/4STGp1tLD4bXJtr+dAjMtc
         oWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=806JURq/BJWrkgeS4g+rrDd0b7ErtjaFevr3VNAOPgc=;
        b=IyedtZMWDjE/Up61TKvD+aG/T/1wytdEYQUcbm0Cx8fdHX1/+oKP/I95O3UQ042m80
         z1OeUHj/CXrMYVEXJqcdRb4HQjm8bBloOwleIZn3OkC4LQcqnVDPkqSwSru+uszGxrjQ
         R1k5RdymxFiRBAi8Aif4aUrFXzTVzP95EKtTawbBkEB2ICDzh4MC72vQyGblF4b+Th4d
         1c9dg9oKfItWN3D1Akaf14taIGLn3OwqvFlT8bPKF8UnlR8EEBWx+mSD2TWBTlYKfx+M
         dqI2vgclVjH5NumxnbJyGVi6wX2X6q/TnxbU+E2BQ/kHyog6GeU7w1SLTLrWerP7k+sx
         lDBw==
X-Gm-Message-State: AOAM531YPhuCnwWAOSprS3at6Mc0SAG2QASL4jv6/1ipGxpToTxehNAW
        lqHkT+NDNu4KHl5sTG+gjv5akoqox997JQ==
X-Google-Smtp-Source: ABdhPJz0zieC1OOcDXvt1yV6B8YFHM+Xdq9M23BitpjX+aG/Vy+eRdvFVoLgLTu0R/qEK7qbCeoIEw==
X-Received: by 2002:a62:9255:: with SMTP id o82mr3474437pfd.218.1592336857256;
        Tue, 16 Jun 2020 12:47:37 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w22sm18294017pfq.193.2020.06.16.12.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 12:47:36 -0700 (PDT)
Subject: Re: [PATCH liburing] test/stdout: fix strcmp non-\0 string
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ec5c66bd2bf8ae8c190ebf4894f58a039c131845.1592336391.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <96ee226c-6146-780b-40a3-59016a9cc866@kernel.dk>
Date:   Tue, 16 Jun 2020 13:47:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ec5c66bd2bf8ae8c190ebf4894f58a039c131845.1592336391.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/20 1:42 PM, Pavel Begunkov wrote:
> After copying len(str) bytes of a string, the copy won't necessary have
> \0 terminator, that makes test_pipe_io_fixed() to fail. Use memcmp().

Applied, thanks.

-- 
Jens Axboe

