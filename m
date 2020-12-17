Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913602DD496
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 16:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgLQPut (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 10:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgLQPur (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 10:50:47 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7434C061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:50:07 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id n9so15261060ili.0
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RbpVSNcHv3ZQL/bYajcMB/ZhKV560/Rxqec8fzCyUf0=;
        b=Mi3FE0eCYjCIVgHYg2C2/HQAknkNy/BnKadC3gvRNLLaprBhgQ7F0qnxoUPwTdA+PF
         +SY1356jkEowb5pLhiDZxhlKbch6DPyaW6BndcloXZPr2tkx5f8EOWihcDyGErYqUwEe
         z12oWwl7A2lXF926/8fiiMjowjm6urMGiWHmpm9Nr/hbOadowKT/yZvaWHIqzbaQureK
         v6OVv+yP+e5aLZcJvWeiK2Vq/w8KH2jU1NoyO77KAJ/OOqvpMUKWCLptum8JeLNJ0sDc
         jOBNHvFXWJjUKEGb3Eth4HgvMdtimRGCR0YfVjAalHaAkzlvN7enxgj1L/8jwXsiIWku
         w7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RbpVSNcHv3ZQL/bYajcMB/ZhKV560/Rxqec8fzCyUf0=;
        b=rXh5NOmN6b4JvkdnCg217o2jFoSJrs2B97fk3PbwUFbnbk3bqhNU9Jc7g2TusDXW2Q
         h485ZjnTWAOgYxlun0rryAJ+xvSoBsnshZQBTEePZ87whJszkTkn6Zy1VPn09TPTURYg
         PK/S+B2GN3qT6pdJjZCFzzdqvRAqIUJ6zgmxbojQNVoY7Pu4nucfcPiRFe+ymdxAL0F8
         rL4XiXxee8PIDXDkZEb4e/Qpc36aP1eSN1YPf9tjrSocRo45GroijCG+K/hacgCo1zlh
         OYeuWQwXLaLjum6qkBBLxUBquCEhUP01yknZx/wYjJy4aEbt3iilwfTsDxGwSECW0bxX
         kSkg==
X-Gm-Message-State: AOAM533JVaR3pQG2VoZiDFrY3fnLVyLoqb5IwFmjH5mtYGndeXu6ritS
        JpIY2v5ZBQsyFXkGei43p7a/9A==
X-Google-Smtp-Source: ABdhPJySXrKJem1Nef8EyVKY+Y+YNvLB6A33TBz3XU2/lFaQMIirJXMMMC8Y/SeSAJ1Wao7YkZMh2g==
X-Received: by 2002:a92:d391:: with SMTP id o17mr6940639ilo.246.1608220207072;
        Thu, 17 Dec 2020 07:50:07 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p18sm3412762ile.27.2020.12.17.07.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 07:50:06 -0800 (PST)
Subject: Re: [PATCH net-next v4] udp:allow UDP cmsghdrs through io_uring
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>
References: <20201216180313.46610-2-v@nametag.social>
 <202012170740.EgQPKuIj-lkp@intel.com>
 <CAM1kxwiL4dD=X18_Crd813nyt_UWpPP8XmwUf10JZhzV7221Yw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <83c3de63-0fff-bd80-422a-7bd7fc414af2@kernel.dk>
Date:   Thu, 17 Dec 2020 08:50:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwiL4dD=X18_Crd813nyt_UWpPP8XmwUf10JZhzV7221Yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/20 4:29 PM, Victor Stewart wrote:
> what's to be done about this kernel test robot output, if anything?

Nothing I think, doesn't look related to your change at all.

-- 
Jens Axboe

