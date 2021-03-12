Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16930339629
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 19:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhCLSUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 13:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbhCLSUA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 13:20:00 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D46C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 10:20:00 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id p10so3411237ils.9
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 10:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SmPkqfMF94yExuTW5+pkxe3JqH8GMdD9tpIq3yeRajs=;
        b=sxng1qGds5bMeQpymrLFTR3UCwzx8o5Vkl0I5A9pSuPXbIpGOAKAEUUfrtT8A1Q/85
         19msT0xQL/bv6dgYVZGfP5TRj9cns/dJnhasyf917cZ0m4YSE6kl1YiaSChJ4DcXMZFn
         Am9INROb84KXu7LQ1RVrSIjESr5albvGyg3nUtFpSf89Iyf4+fs6YptI+/n6baT7Pjc9
         0Rw/O+RXTJAxbiCB0E5Wq5hBYZwnpT1v3jYwG8X+gp76c0qzDUqrQykg+cLaZBkqzKBM
         qvx2jMstK8jAKQrcQrQoixdUxhF3tqhz6ven4GJBdmt/UNgi5mSlF4T6QgKwk21vhK/Z
         yyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SmPkqfMF94yExuTW5+pkxe3JqH8GMdD9tpIq3yeRajs=;
        b=S6uSnVliofu97kzb1d5teT4Y7BNwg3QiK02LcW8muMZhcJeO2aHVVDMmLv+AeG8WAj
         9cpyeST1xXe1vn1Yu+/4sCt9F6e+svkJHliOUe+c+Y6g+QNFJv43UGaoVfzqiiaoz1nM
         JDxMZTuqzRjlFqQOuJvtXUz/Wt/0vnzf3xu1jPhBn6tc+XC3tb8t6PKKhKdWbfoxamFc
         vw9wJtOhahqGBt3i2fgTDIpYwCnrpG1fmkr1Q1MaWzbu9qu5OB2Zp6w1LYiz6SD2Rt/N
         eUwGWb2s3zaSM0uD9SsriZD8YWAxYoUnaZDp6T79gkwPM/jBzXb611PlU8po7dg6L661
         Yatw==
X-Gm-Message-State: AOAM530cGST0fYIkj3sMBASJfR9A24r3IY6NFK6KhEH3PHYfKREmM2UE
        uLEgG6KShHZA449s1Pay4IO0dS84pzkPJQ==
X-Google-Smtp-Source: ABdhPJwkbpcWgUmOJdxDQtdoNpfxE5ksGVzu9YDqMpxRetNUvIpq0rZBqNNiGVPGBzFEhyxkvyDifA==
X-Received: by 2002:a92:dc03:: with SMTP id t3mr1436536iln.76.1615573199272;
        Fri, 12 Mar 2021 10:19:59 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g11sm3165107iom.23.2021.03.12.10.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:19:58 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: fix OP_ASYNC_CANCEL across tasks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615566324.git.asml.silence@gmail.com>
 <153ab0c0ad081e0caa0dd67852eaab596825070b.1615566324.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <99b119d3-b6d6-269c-4a45-4a1f94bceba6@kernel.dk>
Date:   Fri, 12 Mar 2021 11:19:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <153ab0c0ad081e0caa0dd67852eaab596825070b.1615566324.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 9:25 AM, Pavel Begunkov wrote:
> IORING_OP_ASYNC_CANCEL tries io-wq cancellation only for current task.
> If it fails go over tctx_list and try it out for every single tctx.

Applied for 5.12, thanks.

-- 
Jens Axboe

