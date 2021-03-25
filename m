Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139D9349A13
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCYTRb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYTR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:17:27 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C53C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:17:27 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id u10so3128441ilb.0
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yYjdHv6cjxwbISL1Q9jAv393F535wjK/rugm9CcLrj8=;
        b=TFzEC0R5uviyoALgoU4JvSCPVnspBuNRMIqelrAhNPkbC/hUnh+bRUA7Q+PWYCQnYe
         pzpYn6fD7CEkuclF9K9FgsGAZi3l9qmH7A1t30oJiHqe9icQvlFmR9pBLGKUdxXPYOCN
         gmtl5iUA+sgzZod1WQAv0Q6+XGl5PS/kkQAFg5VDoR+/9Rr6dDGG6vlhqz5/ESLicjxy
         saRCDWVEyzcMdnlXJkO0z0kiXdqvMgFNLRy3+YVG9MlhnOw/sPEFrJ+hreANqM+qQTcG
         lj0VAFEbj/3ZwMaNKAeaJQoHTa+E1BRUiSmxZUramAuKnCNJFdww2PhqXP3aHMYJgP8M
         TdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yYjdHv6cjxwbISL1Q9jAv393F535wjK/rugm9CcLrj8=;
        b=KQFhmJ8sQdavOn4Lh7N/Oz/AcDKwk/rdzrmnCly8NiWZ5bOTt1F+ilHH+meYgXA77+
         4JBm7222Hx7nszBFazRVkbO3pS9+oB212R2yAEP8RFDaxOOyOQvtEEpExeWxKV8/D64b
         nZjJIPJL/qVRNrCEC9At1VlyXsBLqpL9GS/aX5lywUw1qTRYOAemEAUmLmN/5AZvzPDO
         JFS0RmD5xEwH+R06VYwBjUdtCryVostZFjs8uFZOMumn5G+7sTHLUHVc9cn6ZBnO3TJ4
         v5NyIPuXWAcAqHV0DKo9xLxjuJe3Re9zFsCXpVryqW40CAKmStYzrXQx/LjhL2rnC1oy
         oj8g==
X-Gm-Message-State: AOAM532+UV5RbvWZnQPfJ9/Tb7hgEJ4tKDBiGj8Il/u9Ze/RcB4vmpwk
        wVkO6GP5GJjSXqcWfTgFwc+5Cac1jX9BDw==
X-Google-Smtp-Source: ABdhPJyBbRzqw18HyQkv21BR9mldKEsBcyNekopNtAyWdJx2EiQmlgK21/8wNb+Gj5PbUgVNGsGeuQ==
X-Received: by 2002:a05:6e02:e52:: with SMTP id l18mr7927253ilk.217.1616699846532;
        Thu, 25 Mar 2021 12:17:26 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o13sm3032193iob.17.2021.03.25.12.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:17:26 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reg buffer overflow checks hardening
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2b0625551be3d97b80a5fd21c8cd79dc1c91f0b5.1616624589.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e8d423fa-5b0d-a337-e921-00697d24028f@kernel.dk>
Date:   Thu, 25 Mar 2021 13:17:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2b0625551be3d97b80a5fd21c8cd79dc1c91f0b5.1616624589.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/24/21 4:59 PM, Pavel Begunkov wrote:
> We are safe with overflows in io_sqe_buffer_register() because it will
> just yield alloc failure, but it's nicer to check explicitly.
> 
> v2: replace u64 with ulong to handle 32 bit and match
>     io_sqe_buffer_register() math. (Jens)

Applied for 5.13 - btw, and I think that was an oversight on this one,
just put the version stuff below the '---' as it should not go into
the git log.

-- 
Jens Axboe

