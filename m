Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B22E261344
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgIHPPC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 11:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730192AbgIHPOM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 11:14:12 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B15C08C5E7
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 07:17:33 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id q6so15481253ild.12
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 07:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rBttBKUTwd/zuUjgIu4QxUnhQUgfwILIGTv0etMXseQ=;
        b=I1P8mFPy3016EYazok34Ad1QcUf2iLPYmeUp0PknXocOfDq2/GFtcnc4Qv05rpLMXk
         7clC9DIsmJmPPwO/4cb6l2DEl1R5LwjtA166+CMzis389B8iJa6ZbSZdEUVvTBcEgviZ
         WuXEJOKuyEkBsZiI1aJMDvtROnhPTvSsHyyB/4dLUpkv5U466ryISxkupc1HqCe1BxNB
         j6lIuL/1VU/kGdlP6HOTn1O49S0kZbv/Cr8OJaJw364dr2n/D/uMa08hxyX/q9k23y0t
         52zyBHPS339cFpZUGUB6e3kBMp2QyULeiGymNhlYOpLPoPoF4gAnzBfRjC+HGpEiI4Au
         Sung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rBttBKUTwd/zuUjgIu4QxUnhQUgfwILIGTv0etMXseQ=;
        b=eCy/+/cACVMo/6BcknbtZqQKeoi+6AQN6/+YjWk3BGAf3MTbYYkssj35ONnoXRv4kY
         PtzV4F7kdf8EuxzumpaTmw8dGjjtBGbEQ4EZeN2TesV/uAx8v+X2/+EjJ4EG243rNsOm
         bKQ4/aMom62dch+YWPV8Z2kADZeb6ZMffdU+gHs274TqwkqIZLJHnt/UEvVzYlhxFE29
         PqJT5WGH0Rxz53I6yhxmiGDFmEHrVwioKTIGzxTVyykKrI4408afwjEbxoQs5yeizFgD
         W3Igu16o/lRc+uvxgNx+tewO2UoxvgV6Gpa+N1hxzKKaZmjUhUE/pHnCrN1ebabcKaDg
         v1cw==
X-Gm-Message-State: AOAM531bCT3ILWwjUSLqTvyZU3MXNZ7VmbHBmPxQb209lQ/L8G4yxOr0
        wvxp1G7L9UH0Fkowis8pUd6dorgMpMauSUs1
X-Google-Smtp-Source: ABdhPJwWJqA6eJK+BxZepf3IZsUM9ec3a1t4cwwHWSsKvIkMk6CwZjW9DZYg1CTK4gukemU4b0LlMg==
X-Received: by 2002:a92:4950:: with SMTP id w77mr22782624ila.93.1599574652987;
        Tue, 08 Sep 2020 07:17:32 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m18sm9631083ilc.37.2020.09.08.07.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:17:32 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] runtests: Clean up code in runtests.sh
To:     Lukas Czerner <lczerner@redhat.com>, io-uring@vger.kernel.org
References: <20200908081703.6011-1-lczerner@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f3f16e40-7c38-5eff-1e1a-7d67d3f62e3b@kernel.dk>
Date:   Tue, 8 Sep 2020 08:17:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908081703.6011-1-lczerner@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 2:17 AM, Lukas Czerner wrote:
> Use uppercase for global and lowecase for local valiable consistently.
> Don't use single letter variable names and add some comments.
> 
> No functional changes.

Applied 1-2, thanks.

-- 
Jens Axboe

