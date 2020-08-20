Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CEF24B9B2
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 13:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgHTLxk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 07:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731012AbgHTLug (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 07:50:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AD5C061385
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 04:50:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ds1so863573pjb.1
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 04:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FFXmvVk3cBNsboCVA02eCu9vXzyL+/4YJvadtLwzyiM=;
        b=tSI+sa5aEFoC7MUVFBFYmyJjeXohpBlehOb8K1t8EYXRWo5XKs9wtgBQUMU4HiFhoR
         1MgvHUiVJkofcPO80GhS3WMrBw99ur/2vB+oMdWNBBGZ7J2PfK+Mi9cpE/t3JN9ytUCO
         noIGTF4HNtlSHaGDA7XbbbHk+BdKCXtqiyCzZZSxg6DOT34nOsCMj3TkMlN5Ky2LRph/
         0bFb9M6cYMxCHrwm2daSAfpy2sxLx5XwFJCHybjgf2cyur0enJgvjpx7LPiR2kmL08bW
         iHkvU0WQ75UFUD6XCeaz4noDzKQ4UnBju10uRCR3DkguKgiEFnJEJ0vVgsQNP6F1Cb7G
         PDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FFXmvVk3cBNsboCVA02eCu9vXzyL+/4YJvadtLwzyiM=;
        b=kr30TEyRP5QsR6LQmcnay4qiA2DtR15JCZa9bZ+E564n3WWmk6wAhNHJFDYR/jFu1C
         pHuRSkgjY0EAeiOZa5xxeFBNDImGWV11OT8Wk66zebiC+RHpGRcNvWa9hnn7RApSpEMM
         d7w91wOH6sFnWo69LNUeXzX74k5vDMJwW/Or1O+iTXPeLk6f3cuMnmD1pWaUttx/TrAF
         ltnD4/LfPQtq8La3wZnj2XZ5CHbBAuYfM0gA4Wa2dFAcaA5LEG4KYP/KQGE5zG0Dt7C7
         I2y5SkUK9VzReuXFQS9QOJIhxnQTbwGjRUysfC+/CmIULGNA26kYg3nCEF/UF+ZpMCY2
         aBqQ==
X-Gm-Message-State: AOAM533rjjNjids7fIiz9McAowlRgWZIrEsqOdS2MrxyjTBF8ps/rhyC
        hqSpk9edXauHe4iZVriuLnYDjb0Fwf4fyNbBsuU=
X-Google-Smtp-Source: ABdhPJzXfhdpPuPlkh66Ox1A/zKM9vttOMqG0u+ZUat8zq03pBlMg6Z77iwB4NIFTtRPdUFl3K9tJA==
X-Received: by 2002:a17:90a:9bc7:: with SMTP id b7mr1375649pjw.31.1597924234268;
        Thu, 20 Aug 2020 04:50:34 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z29sm2649199pfj.182.2020.08.20.04.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 04:50:33 -0700 (PDT)
Subject: Re: [PATCH] io_uring: kill extra iovec=NULL in import_iovec()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c61315205aeac2a480ca8c49da92f7ec1dcf29db.1597912347.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9cbc1ef7-5231-ff84-1aaf-109d9ed8f9ba@kernel.dk>
Date:   Thu, 20 Aug 2020 05:50:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c61315205aeac2a480ca8c49da92f7ec1dcf29db.1597912347.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/20 1:34 AM, Pavel Begunkov wrote:
> If io_import_iovec() returns an error, return iovec is undefined and
> must not be used, so don't set it to NULL when failing.

Applied, thanks.

-- 
Jens Axboe

