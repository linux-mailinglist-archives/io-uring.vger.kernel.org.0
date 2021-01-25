Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318D9302788
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 17:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbhAYQLd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 11:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbhAYQJ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 11:09:28 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CAAC06174A
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:08:47 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 31so7866093plb.10
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SFw3fyaTmIIwJoxAYZMBYL1d62R/05tjQm0lM1eaetQ=;
        b=jFDkpBz9GtQ6AZIeO0oZesKR1MqjYhhaNoOj7u9q5eEd4dL3Z0NKTfk7ELH6NZX7/o
         TdBZF+T/R3XHo3rbEbaUdOTHmE3q/LE1NiXqwMCZtdUnYkX1ATuseRkjoCe3atOoDJRI
         eGglKDEsMrE1eiy4U+mNdJap7EJSA66YsKlnP+MuQNc2mgmbophAouB1lFS4VvJ0CFTP
         3flIaYjNhSlU4UZBCrnpFLMNbI594ybunsHR7p71AHtbo5A/Hm+MSZazt2mKqmt5lnGB
         FC5Oba2YElmooiqPRW2iAT8uc9bEqMc8IAtYa4LUaV1GxKgkZ5nydcH5U9Zg0wj5jWK9
         OV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SFw3fyaTmIIwJoxAYZMBYL1d62R/05tjQm0lM1eaetQ=;
        b=BefyyS17MKVsmvB058UCWrbWjuOcH0PBfnQyPSjaS3pR0m5/ZPZvHJH0ajBF/b72qc
         p1z7tUCQt8iJUThMMkmXXewFY2HBGFAIX6CMy6AKGP3fSzsDDg5ZVbEMiZrw7kohxB1f
         yNnfk0ca9ihA8OnKcyZpd7/WidMzOJ/02usyBg8quyQUBsJhZISfruS6z6YSnXPz1Zlr
         iaTjmVSHC8Zwc79ZH5wJwnxsXBVHGggB8+dKOWlGR4VN7Xhmzi7JzwXJpmT08n/wpyWo
         8eBJeoH9fI6NDlATJuTd3pyAEt5Uuolkc0AcWzVvCzELNUd/o8CXvGMzi1tkm3aAC/Vz
         SnBw==
X-Gm-Message-State: AOAM5306bSW21NXqe9Vdlz7UuIjPXBIuoiMRkub18GUe9k/oaM/jTKaI
        mrLjVDzcQ9Vf9srOBQiQXDUnlGQ7JPmxxA==
X-Google-Smtp-Source: ABdhPJyBYN0jnkapcrm9sfJ232nb/xwDFYNX/NB/U98r44FGRQ9B5AdpogVDlpj7zANbL1OMi9xupg==
X-Received: by 2002:a17:90a:6549:: with SMTP id f9mr921290pjs.17.1611590926335;
        Mon, 25 Jan 2021 08:08:46 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j10sm18929638pjy.9.2021.01.25.08.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:08:45 -0800 (PST)
Subject: Re: [PATCH 0/8] second part of 5.12 patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f10dc4a5-9b2c-da65-bb62-00352aff3926@kernel.dk>
Date:   Mon, 25 Jan 2021 09:08:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 4:42 AM, Pavel Begunkov wrote:

Applied 1-2 for now. Maybe the context state is workable for the
state, if the numbers are looking this good. I'll try and run
it here too and see what I find.

-- 
Jens Axboe

