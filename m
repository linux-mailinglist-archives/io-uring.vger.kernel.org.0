Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB8018D165
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 15:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCTOrJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Mar 2020 10:47:09 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:44986 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgCTOrI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Mar 2020 10:47:08 -0400
Received: by mail-pl1-f175.google.com with SMTP id h11so2559133plr.11
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2020 07:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eODrjtlhxOTiOIE29YNGxawgf2NuIiCFtx3U9eUdR1o=;
        b=w2sFeTI6xJny2rlGP3QvwgvKrol5h4Oz1YzCAoOMRXvp4o000AIUWmX8FEn2K5OiPn
         6BVDiunczPvIL8iRhyChvNqjU0S8IOs9hvHW0NEbfjshSt9lgdCVhDogdhTTrMmQq8gh
         uyNTi5zaBhlqzhVWTH+M3I+lAqTozXSpwb6MBhmL+dpTVkr8pfbyo0TW/iwvL2G31kQk
         Lcb14BEcCo3e2C2FRlMQpki840wWVsOBuOTedpKfFbu5AfW6z9/cwV0PgF0jRH09KtvA
         jUxy+Z3Cy8GSkVEAdg7JQdIy3ub2j2o8sAdmP+csDZ5haHwn/AXp9EtyuG1Qtgj6pJ5N
         F2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eODrjtlhxOTiOIE29YNGxawgf2NuIiCFtx3U9eUdR1o=;
        b=ZDhqe0bEda1n55ex0euWDfoKJSOJAooT5oczuigjoEjQ/kN/sQaMJB08/RGZeSDxUv
         ycv5S0rpoPrCfzb/kYWmSFSSFgDWu88uKh3wqL4VdB5qSPfTxkROUHMsHwghFaZNN3uc
         0UVwottH7b75NIXxhI5DEX+pTyvXQeTpPHx7Mk9BAbixKaVubCc5tlxuUm+VBSEXSFoO
         FqZVJJYtbp9XjiKKzUL2T3Hzhcn2Y3urIBMH10qkcJXZJEJrr2HEv1kP6Wg3Ig5E3k6V
         Rwn9seR41TWbm2OGBRdeDXhIiyiDGImUOp6oo7356u1h3WbC1SlWVA5ySnjVpzDQO0Ss
         5moA==
X-Gm-Message-State: ANhLgQ0tyyAIHGe55conY2e+ix5Pw8PsvISWhG+WY0a17T5bfeVb67xn
        9WQ12IY0VtCFJeXc8/1vmDLlB5gKpLmHNA==
X-Google-Smtp-Source: ADFU+vsqSEowjDLSywdfclAM2jdlEQxjMlIhM+WhoToPLcwc4KbuToihckNI/5uQvMbKvV4AV+QOhw==
X-Received: by 2002:a17:90a:7105:: with SMTP id h5mr9929862pjk.54.1584715627077;
        Fri, 20 Mar 2020 07:47:07 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c207sm5763202pfb.47.2020.03.20.07.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 07:47:05 -0700 (PDT)
Subject: Re: openat ignores changes to RLIMIT_NOFILE?
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAOKbgA7cgN=+zNVH9Jv1UHXC1qoWAgnPqZPPJuNaLUzzXOwwSg@mail.gmail.com>
 <67f104f9-b239-4d68-2f90-01a2d5e30388@kernel.dk>
 <CAOKbgA5RvZrf=RD-5rp7gug0-SgcKaFY4aacup982NvxYTPjSQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9de6d5a1-5937-c564-648b-23e6db4c73ef@kernel.dk>
Date:   Fri, 20 Mar 2020 08:47:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA5RvZrf=RD-5rp7gug0-SgcKaFY4aacup982NvxYTPjSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/20 8:03 AM, Dmitry Kadashev wrote:
> Hi Jens,
> 
> Yes, with the patch it works perfectly, thank you.

Great thanks, I'm going to add your Tested-by to the commit.

-- 
Jens Axboe

