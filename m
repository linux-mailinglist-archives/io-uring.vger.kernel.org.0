Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9284078C9
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhIKO0u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 10:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbhIKO0s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 10:26:48 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D61C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 07:25:36 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id a1so5192888ilj.6
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 07:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2x2QrVqn80+ROHz6hLTLZY9V0EurE0PUOLumHIEGyaI=;
        b=MJdmI1gPppb/JVBAKtLCAN/hDMg73WVbV2rI749GL0mZHXSBHyDxprlqDb/seUJptC
         CibyIPfcfgGAV9JwI7twx23ap8PmJX4XBixEun9gj5fPXWD5ack1BxpBPGXPv9PTCqUW
         17CAm9EnpQk9W/Y1XFYIO3XOBu8LPLt5N4A2OgpqoJAhyTdcYxz01i9zhO5QAO7oksMj
         s3H1VfXMRMGsLuhX2bhW3TDTEVhYudpX4LkyYV/o9mTyFEKK914Sqtjmu1YTx4c2W1Ss
         U9UiOf3dMIZWX/q+NGTgpHQ90bEwyqJ7KeIoEvLPBnh0iVN60+t3T6KLmmnUEnmbTna4
         SdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2x2QrVqn80+ROHz6hLTLZY9V0EurE0PUOLumHIEGyaI=;
        b=532ZSMdPg6VBIVcAtl+p9meEyQZo74TXOtX8VEz0gXSHZUtYItQU5+Dez6PSJWPG2n
         gojFG3F3OOFls9pCqH15R4yBmX/uW0dlXXa58qw4we0CYvFZvfsaGmd6MPE7degxXkOH
         QtlD3NIUSMtD5R2PviAAZLmkNtncaTIwboJnXR13qfv3uzm3lqFg2SRu9gq3nE/4/RZv
         ubSyFo7A7bPyLn0pYk9D82V49O//4Oh4gKXGYE9rut914+HARtD8v33OqgUX64hLDrfv
         toc4lyAuhJXG/jR7APAZmPSH0ndKTPu8EuFYbAtlD41Hybvrf8zhyJdZT81sP7X2pMuj
         o+0A==
X-Gm-Message-State: AOAM53240aRkMD9YdRV0QWH6L8gIBnE1cwwCatFDItcWEDdxAOvlBRi6
        XWYszkfRQVXr5JV9dt9VLoIIZ5HQOIUM1g==
X-Google-Smtp-Source: ABdhPJybiNNjAvGFgc2JX6kU63u/Esorvw/3MlD/qAewsGP5fcyF14tnvYyDpnsGzMgwNjn8vzmWzw==
X-Received: by 2002:a05:6e02:128d:: with SMTP id y13mr2000655ilq.100.1631370335400;
        Sat, 11 Sep 2021 07:25:35 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i14sm962024iol.27.2021.09.11.07.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 07:25:34 -0700 (PDT)
Subject: Re: [PATCH liburing v2 0/2] exec + timeout cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1631358658.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e262126-5fa4-5319-43df-f30f0e86bffe@kernel.dk>
Date:   Sat, 11 Sep 2021 08:25:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1631358658.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 5:11 AM, Pavel Begunkov wrote:
> Add some infra to test exec(), hopefully we will get more
> tests using it. And also add a timeout test, which uses exec.

Applied, thanks.

-- 
Jens Axboe

