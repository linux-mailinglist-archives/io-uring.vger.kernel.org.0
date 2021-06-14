Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5820F3A5B32
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 02:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhFNAs0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 20:48:26 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:44646 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbhFNAsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 20:48:25 -0400
Received: by mail-wm1-f46.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so8657851wms.3
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 17:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+/rYhODSJTC4K2IaiLVXC5hW9isPcpghouqIulOBF38=;
        b=ndISWlqOHYAAuD2pXhn6EZGDRNDAXW+tggmncEYrJFmMEe7F+oCHkIJgOxsJVXbFsJ
         aFxixFniEbFSeMm8OKF9PmsHZUGdIEJiWzcArAMFWIqK4ui9mXImpP4768Z/FvFnOSuE
         BKtxeaCxO/48lgjPdsZcRhWfFk390fw7A3SBBFCF+fGzOa8+HkL5KkNPv3mz0/XxrBS9
         Zkdaggj9H3MwMAxEgelNuYsjexeZA0QIZIncKQXbIN+/ClpXTkegU25402e/6Huvqcqs
         PMeXfES1OVHfGiiWWzT2wvwuae7ZzS+cFVPk1iwmvxtxUDOU7cVgSeoua7xJSZ+tZ7+m
         mJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/rYhODSJTC4K2IaiLVXC5hW9isPcpghouqIulOBF38=;
        b=uVrNUjMQOU+3IVUM3S8EQ1L+h4vtj6Rk5i+3OURK/S7V4LUcGKGNJOGXhz1ItVISqx
         dL5m++40GaqQtGlIaDOLdptky7VvqpqMpr2z5mYg5wE/BiocVuKOsO/d04FGO6+AM5Bn
         OcJiD8Vm4bzecjSwIpl4FN3Kkx7yt9vo5ZMMpeQbdLNHXsSlBgyrmorxrqyU+czUAmah
         bsIgISWG22mwy6RcUcC+5Q33au4PNoPRb4S4nprwTQWVFhr7AIGjVzlYB9aeX8fqvp8M
         A5w2Y36/8D2x26cCc8fyGZUShj1aRbARX3Oqrh0d5jSMGlCT9s4jBQinV53RPMqwQymP
         0zIA==
X-Gm-Message-State: AOAM532Bg91dKFwOqGq85NVM3XPKzRCbNH+03mK2uIofuHx7TRrYBWRt
        Sf0FPLTMmKL9U57Ona8Dn809kn7x4DtXSQ==
X-Google-Smtp-Source: ABdhPJyDF9c1H2K1FOkOV6iHHXUCAhIfHnni+18vJEnpnk+hjWf9ri068neSFTBVvk3r/7EyMbwJjg==
X-Received: by 2002:a1c:f60f:: with SMTP id w15mr29878681wmc.5.1623631514620;
        Sun, 13 Jun 2021 17:45:14 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id m37sm10931642wms.46.2021.06.13.17.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Jun 2021 17:45:14 -0700 (PDT)
Subject: Re: [RFC] io_uring: enable shmem/memfd memory registration
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <52247e3ec36eec9d6af17424937c8d20c497926e.1623248265.git.asml.silence@gmail.com>
 <355210c4-7b2c-8445-b8af-da40aed2af26@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <bf49b46b-2e5a-06e8-0563-294fdfd30fff@gmail.com>
Date:   Mon, 14 Jun 2021 01:45:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <355210c4-7b2c-8445-b8af-da40aed2af26@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 4:12 PM, Jens Axboe wrote:
> On 6/9/21 8:26 AM, Pavel Begunkov wrote:
>> Relax buffer registration restictions, which filters out file backed
>> memory, and allow shmem/memfd as they have normal anonymous pages
>> underneath.
> 
> I think this is fine, we really only care about file backed.

Jens, can you append a tag?

Reported-by: Mahdi Rakhshandehroo <mahdi.rakhshandehroo@gmail.com>

-- 
Pavel Begunkov
