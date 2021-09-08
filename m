Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA31403850
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346624AbhIHK4i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 06:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242347AbhIHK4h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 06:56:37 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F639C061575;
        Wed,  8 Sep 2021 03:55:28 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id z4so2602401wrr.6;
        Wed, 08 Sep 2021 03:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FSTaWXnIcohJwFSAhfLyS/uraqddRYz4oZjK4C/gjJI=;
        b=dt/z7JvnHPnWNT0lobOER28shIcc0fVfFXuEoWvzhdevMj5POmdv6MNcO1AqvKwtS+
         YDhr67YyBuiXhkq15ZdFElEsAhWBdyA547qjk7EYrtG33uDFxpMHXENS0dxRaf+/7HWP
         U6qqVYa86hLH1GDmajRY3uDRCLwgKbNW3eA6vvVS20sTgGfkQ+K98GBGpLWv3S8MIyJN
         F2VM1YIZPc+raPQhdXJVD+BlsC6eOPAFkIlFY8d4fYTvxybhwViXuksdxsprQZGZ4rOr
         BpigKwys0VfVLiEJLbqRbWIjBvYCF7lHS/b0jKcc5INNXswpXumLOneR0rN5x3s0yGaw
         2oAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FSTaWXnIcohJwFSAhfLyS/uraqddRYz4oZjK4C/gjJI=;
        b=T3j8E6LuFavHo9E/WJT/eAi67TJ3x3juhq6SgkbJDHLzP4mHD4A/SRiesAiTkPwvbW
         cU51iyzWsT3qeGxzoW89/U6w4xw3JYQ7fPRrnIEJBTKRMYgyJxpbqwoxP4ucxTuCCsQ5
         sFISV71XqPgXIE8a0q12qn+FZzoCA6B0Df4j4qq8Zsf2SZo+UO96AZDbS2A6dEBPqo9q
         qWZGIAlTqUDPA5VL86992vsL7mbAz8ZGhrI1qzeuW7aFjqgNNtj4+a5mjR/O/jq1pTa8
         tc+Lv1cYKA/M+kWqUJ6SvKIO/QR2ZblAEdrinF897bKSwbzqcbzyAl0WXIit+5uVPd7m
         E9tg==
X-Gm-Message-State: AOAM531Bbi+c5BVRpHiKaFL8GQ6pOMJWOpS2W/JynTXroidooK8ukZi9
        V7sGRXCO2CieOZ+XuLA2778dQFtcQaw=
X-Google-Smtp-Source: ABdhPJwcaySZvBWFXwnjuw8akCTIMJwRKaueGYETRj+oYQ6Y7C78uMvEqnCN3GQIScZM3yc+Mjyolw==
X-Received: by 2002:adf:9f0d:: with SMTP id l13mr3361201wrf.328.1631098526824;
        Wed, 08 Sep 2021 03:55:26 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id o5sm1794486wrw.17.2021.09.08.03.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 03:55:26 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
 <YTiPoKc9GiG52DNd@kroah.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] /dev/mem: nowait zero/null ops
Message-ID: <b03a27cd-1e5a-9444-c406-e15c52d2a066@gmail.com>
Date:   Wed, 8 Sep 2021 11:54:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTiPoKc9GiG52DNd@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 11:25 AM, Greg Kroah-Hartman wrote:
> On Wed, Sep 08, 2021 at 11:06:51AM +0100, Pavel Begunkov wrote:
>> Make read_iter_zero() to honor IOCB_NOWAIT, so /dev/zero can be
>> advertised as FMODE_NOWAIT. This helps subsystems like io_uring to use
>> it more effectively. Set FMODE_NOWAIT for /dev/null as well, it never
>> waits and therefore trivially meets the criteria.
> 
> I do not understand, why would io_uring need to use /dev/zero

Not directly, users can issue I/O against it via io_uring.
 
> and how is this going to help anything?

For files not supporting nowait io_uring goes through a quite slow path.

> What workload does this help with?

Personally for me it's dumping output and benchmarking (not benchmarking
/dev/zero, of course). But I'd also expect any tool that may be using
it but rewritten with io_uring being able to normally use it without a
performance hit.

-- 
Pavel Begunkov
