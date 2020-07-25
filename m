Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5D022D880
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGYPsP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 11:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgGYPsP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 11:48:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F41C08C5C0
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 08:48:15 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f9so908794pju.4
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 08:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UjGjOTucuQx950dHaC8N3Lkjpl0aSUSZWvHB3qkH3og=;
        b=pE05VwZVZ3pTG+KetVi2rGuGnUqF49dVJZJkrlM12F/l+zMdzqPM9Btv+0LcqIBirw
         aTzBSwcksmTQyjwzbZkQfrfT01f7JZ9lk/WiRFMXFoGQ8bht1ogHBlTP8dxWuji3xo8Y
         Xp0SR5BpvnhrEQn8hogfQ3Nj25m5vcEri0g/XN17teQHDpzfDlj+XiNV+ZuLMUExiy+M
         wvtvYgYVaIDEwfLIm/pwyQrKxD7iVi541FSyoaRIHEh7CXqUW1ze4gYpJnRpjKq8GTpm
         LkFR8nV50A1/hzCTt6qz8Ucwu3SMpL3/1+ikemmeYgaOx+dI2SG8s5j+bdvSxj06GiAh
         RI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UjGjOTucuQx950dHaC8N3Lkjpl0aSUSZWvHB3qkH3og=;
        b=atsWH0AymecBr0cv5I8Vw8QUwoWddRTjFnLdW3SIxZTlS6KoUwbe0QkfvOHO1dGYr8
         94I0zxljSUF9oL1R6DBgXhXf3cnOvLDSk888o8q3oaMtrH4v2F6bFTArU+r3QMFgc9nq
         FEHDfgb/v1xC1nWECVFBjxSI9KzShqv4abWFg28g4hl1XF3OE+KfF2k9GzJvbpJcAzuT
         MX3EReGhlmrAqSl2wFRt+uS4QM6MVpvfZ1tNKqdI3vcEbTLmQRACXUbhhfbYLycx6E2U
         IQsDIQ7RkBvYf6hIF92tzLAJDEVUHrVUajrHhLvmfOkN+QZMceNUuTHBIcB4q9oIvx4p
         vX6Q==
X-Gm-Message-State: AOAM530ARe39GA8oRNljh527Y90RyGj4AUkV3lGYN2uEUwEXnwqKevO0
        mX5GQBb+WCLahS3XVQ+7tpxiBHzchf4=
X-Google-Smtp-Source: ABdhPJzBdvDH/gooqy/AHwqCfe7ZSfKBvupl2/SL2kh4lexPMn66uI3Xspqaje9jPoFmSnM6HiH5ag==
X-Received: by 2002:a17:90a:d081:: with SMTP id k1mr3077482pju.177.1595692093096;
        Sat, 25 Jul 2020 08:48:13 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n18sm10078140pfd.99.2020.07.25.08.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 08:48:12 -0700 (PDT)
Subject: Re: [PATCH 0/4] 5.9 fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1595677308.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <11b4d4e1-b93f-81bf-4307-4482e1400898@kernel.dk>
Date:   Sat, 25 Jul 2020 09:48:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1595677308.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/20 5:41 AM, Pavel Begunkov wrote:
> Unrelated to each other fixes/cleanups for 5.9

Applied, thanks.

-- 
Jens Axboe

