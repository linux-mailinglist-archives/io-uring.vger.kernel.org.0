Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DC13A8B69
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhFOVxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhFOVxh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:53:37 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E544C061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:51:32 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id q5-20020a9d66450000b02903f18d65089fso385372otm.11
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ItJk9Ghv8yIkGYbLPfxSoCvBmnCbXTpV0jG4iHLpYy4=;
        b=IIrYpJa1hivGRct/dLtO++4CKQg5+Kk1ellVgLIkdWDt4YtQukExWRcZZSo7v7u4IW
         84qPpddurdeZIvw1faFGdBcvUk6oQDV4cV7QqlY61SMjXTxRU0epWuSkUAYiOXgdgXgE
         9pB7Wjk5l4UK5Xwr5NhtZ4/WaWllm8EUUMzubjmoXyV4XpPcetX6+7giaLMHZ+MKyGK8
         FvAOCn7Qphuy38voaBNlCDtTS3oh7iI2vVH4LuZaN1UedpZWeMnzCUgvHr24B3zm6TxM
         0BPvb7v8nzsZnAA5QB9RK3hSDzr9iJgV9ocqDipql9WGL4XbJoxNoHv2x0bq+mN8nOk5
         lgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ItJk9Ghv8yIkGYbLPfxSoCvBmnCbXTpV0jG4iHLpYy4=;
        b=UqIXDrGu5g92Clk10FhLMITZFif7+lDn6SR9+kXDs6S7HTYkmuqXMREWIT9HMiAU2x
         rvJCL2UwNIzNpcg192MvVDn8qH9r3Y9vbnpVUXuX7rU8g3/JKAUtVuZD/5F4muFQ00K0
         0uYwajxg8KMq/gwGJz4Zong6XkkQRLcsZ5xwL16HByBoQZE9B1yvdmr33fFmlFbql4Rm
         PyjY4WVAltKV7MC+Lb+V5BK3lc25EkTakwChQ6/OokadX5npEx36eVD7QV4kltXCJlk5
         5QjFIUV7O7PLx/P7q2QtVHMN6A04uscytdtHl1RkXtTnjxft5MaR2cmJZyPzp2tBRONY
         yzSg==
X-Gm-Message-State: AOAM533YCmoUa0As1pStdfIdqLb2qOiq4BmXZU3FhgpodEkrEuISpzsV
        m/6CpERd3f5R9S8eYNJXRIBc4Q==
X-Google-Smtp-Source: ABdhPJw/JMvl2ceUXyIaVlgQVpTb/hJ0k9r80GjS13z6Cz0jpk+1XV6b3uTTZhk31n/DqEJzHzm0gQ==
X-Received: by 2002:a05:6830:93:: with SMTP id a19mr1100081oto.17.1623793891829;
        Tue, 15 Jun 2021 14:51:31 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id s187sm36343oig.6.2021.06.15.14.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:51:31 -0700 (PDT)
Subject: Re: [PATCH] io_uring: store back buffer in case of failure
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
 <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b5b37477-985e-54da-fc34-4de389112365@kernel.dk>
Date:   Tue, 15 Jun 2021 15:51:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ditto for this one, don't see it in my email nor on the list.

-- 
Jens Axboe

