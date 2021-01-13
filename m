Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B02F4EC4
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 16:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbhAMPa2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 10:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbhAMPa1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 10:30:27 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8009DC061575
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 07:29:47 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id b19so2374350ioa.9
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 07:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=J/edMufaWCeKIlZiTCzQqlVS2BLMSd7YcUZjqZopPw4=;
        b=AQbMm9Lrqq0h/jpZQHEXmxe0rLwQx0KIr70Z6/QgWfbR0aHUXnitODLfpR1LL+oRNe
         AKMHuzdwhYFodrdRjzPithDv6xhRO35EKfFlhKvBL/ypATYmPiSO0U/8RaEE9MmdICYM
         lxw75PkWGYPQspimVM022nHksqhJUb8VXAf2N3yX6UqTYdT+Ef0nySuFVj3bApomSCNA
         pn6HVliRohQ+qlwp56TbDrOB3VMBLZ5HNfTZVurTc2DK0RNJ/XciqddmdN4+tR9p7eVt
         keuGgo+w5i5WEeI6+k8mBJ3/Ir88RC1BYP8iY847/blNFh71W7ZY7JEHBVr29Ia/ru3F
         JD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J/edMufaWCeKIlZiTCzQqlVS2BLMSd7YcUZjqZopPw4=;
        b=GPs6ntZHgKGt8LPsNPdXa+k3XTI/CEkc/d4HC0sBjkk4c0yOk4Adxi6hmiMVYIhJ1u
         rKhgqoBg6vVWFBS1FsrW/6ykbnB7HxXPIXQhZkOT7akZX6npvQo3BjceoqGxh3U7sMG/
         rqHQ+MIHZXeoyfs6D5bVQt3QxfILhjsNeghUKu/TW5s2MoDshF9qcXUlUIBy5JLHRYhs
         OTzGRuJcHbSriYgksJe3TUpmadU2qSrmtKaZ5ikEzgzMLTaX/3JhC2YkH9X/idvqKuJ8
         lXzdSpZYy/lbA1BBouXb3ZewE2wP/8vZ1VkkvmnwNFtB+ldGqkaurK7VV1BKVnP+OQqf
         JAsw==
X-Gm-Message-State: AOAM531JwgEdMbZPIav8KOVXQxtDS3aVNPyGhH/+wxHo+xRD1gjagXjy
        OdSs1nCOLwo7C+fPoH8czq4NxS7qFnu94g==
X-Google-Smtp-Source: ABdhPJxWaOSNyiPMEneL27/ejSF4WOldT7qhjWWIKVVd+aAp+8IhIM2a73V5VpeykUXnHFPRKepHaw==
X-Received: by 2002:a02:37ca:: with SMTP id r193mr2925159jar.33.1610551786523;
        Wed, 13 Jan 2021 07:29:46 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 11sm1643149ilq.88.2021.01.13.07.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 07:29:45 -0800 (PST)
Subject: Re: [PATCH 0/2] syzbot reports on sqo_dead
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1610540878.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fae84413-2447-28de-e679-9d7c85092fe9@kernel.dk>
Date:   Wed, 13 Jan 2021 08:29:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1610540878.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/13/21 5:42 AM, Pavel Begunkov wrote:
> It deals with two ->sqo_dead related bugs reported by syzbot. 1/2 is for
> overlooked ->ring==NULL case. 2/2 is not a real problem but rather a
> false positive, but still can backfire in the future.
> 
> Pavel Begunkov (2):
>   io_uring: fix null-deref in io_disable_sqo_submit
>   io_uring: do sqo disable on install_fd error

Looks good, thanks. Applied.

-- 
Jens Axboe

