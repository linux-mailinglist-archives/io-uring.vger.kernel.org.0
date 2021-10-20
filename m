Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60574348C9
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 12:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhJTKSL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 06:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhJTKSL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 06:18:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF19C061746
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 03:15:56 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id d198-20020a1c1dcf000000b00322f53b9b89so8956871wmd.0
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 03:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ysqyGz+NinvvZEqQkxmkSiiIh8ybm22Fux+g+CVqly4=;
        b=D+eKQ21py+I4ntOcwKRhgeOCeqY1CFZKHu8Efee1EQbKrxVvS3ASypKX8jWeyioD8D
         6DVOFbJL79kUTa6YrGD6Ad5y5fjxJfp9wm2f0Qv2nkvIa/Y1Au23WNljHQq4rDCXOvAP
         knK7W/DPOhV7l/Is0JFrZm+xXWogbNvm5ClTWzUAziA1gQvtYYj9ODhnUAaTE0lniesc
         aCWzJGs84YyPq+jZVrxit8P5PMvCqGdBRYWZm2xuZwripUrpxQtMN0FpWtndO2OsIhLf
         5mr2MhTg32onKj1rb1Npv/4pGl2lgL/zGJz79vDoTaB+a32eTFqhdo7gNAWXovKtEJE7
         zmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ysqyGz+NinvvZEqQkxmkSiiIh8ybm22Fux+g+CVqly4=;
        b=YX01QgojCPayUEiyaHnWBDt84K4beXEEUA0umuBUbcTe4dwR5hHxANzPvmol1uoN53
         ykKoKBWAfMroZ6VQKIz29gyH6n7i42VDXMonF2EkX3HN9xjqFJVAN6F/1vb9Alp6G56Z
         OwtWKlHs06SB6omMuPX5Z0V0ElKEf2DKZm31VhEQtVcyLFDtfbuRQRZMDqXgFaGzori+
         jhZPNUy1OlFMGxL5jPbSNXDaPUPmdzhVom7vQNBt31aNuPOgI887N3zraIqf/ZIgxDae
         E+J0B9zonini9R4dN2JBZi1HdhE9uZhudqPFbjTkYylMcJ8fUZ3iIP3evt1ljX8X2Sae
         oBNA==
X-Gm-Message-State: AOAM532ymypu17wszFPXg6ulYTtp8fjft5a8qLwoxdGiBClVd75lgoo6
        l+1kezgO7NPUvFJwIOQ3YAFA00jN/y1zXQ==
X-Google-Smtp-Source: ABdhPJz4gad22P72p1A/cFlOZUAvqOezx2ofeh1DxM5ScNoU6PClE0hadAVA5yZ1C9syCPHRylz8Nw==
X-Received: by 2002:a05:600c:4f53:: with SMTP id m19mr12473240wmq.118.1634724955621;
        Wed, 20 Oct 2021 03:15:55 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id s8sm1623577wrr.15.2021.10.20.03.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:15:55 -0700 (PDT)
Message-ID: <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
Date:   Wed, 20 Oct 2021 11:15:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Polling on an io_uring file descriptor
Content-Language: en-US
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 10:21, Drew DeVault wrote:
> I would like to poll on an io_uring file descriptor to be notified when
> CQE's are available, either via poll(2) or IORING_OP_POLL_ADD. This
> doesn't seem to work on 5.10. Is this feasible to add support for?

Not a canonical way, but both should work (POLLIN for CQEs).
Do you have a simple test case for us to reproduce?

-- 
Pavel Begunkov
