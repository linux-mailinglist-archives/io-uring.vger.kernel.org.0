Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D700822B942
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 00:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgGWWQ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 18:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGWWQ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 18:16:27 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB5CC0619D3
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 15:16:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id p3so3988528pgh.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 15:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2VYTIlcw9c+rtpyVS1Absmi+UGWN9Jpbz6G5ijmNG8I=;
        b=mi3LRVSN30Xuuyz0izKIXepF3CLP9xJy37C5IUbWV1yMxGk3G6zRl3O5CfJx7BlvtC
         wZgEopirc4dt2wL1UBwlfNi/Hau1hEbJaJ91H7mvGVpbQfjMQkLShNhM6fzmwejbkXfu
         ym4E2p3NdN3QLgmkGdpzX+vPFo2UT4yGX7SdOVHLww9s9l72ow9F3ojCpWNCH5RMBdM/
         PlRaVXR06ynzVLcmvnF4Z2HE63DWlGB52tYJ2gBGXtN+5KFUvzMc/cqKMBs5CPMZIWgE
         OLxPwmsF4tNBz40MS+wBop+uPwqpmEPPfjZgG4D9Sh3SYBI/spJx9E5/PbpTSX9HFZQf
         X2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2VYTIlcw9c+rtpyVS1Absmi+UGWN9Jpbz6G5ijmNG8I=;
        b=D6fL2mHkDCoUqoySYowEAUiDh/chxx2ABAqK7wqYLXK4LeiM4ODCh+Wn+btpiaSTDT
         nqVO6VF0Joh81X7k/sHUExtoIwomrxbISzDkDkyryrws2uUHOfNveZKEveaiMiBDgMNs
         3ShVtXSGulUWWMFFCyAPEUi0ZIEBVh4OMDPOYiuqQOxnzhnN/9U14C263zDbOwgFwnjz
         WQIfSFCjHmaQPeQ/QP046mUOnGo1uUjh53ttOIITg9ypvTOZFpgvKnn2zLpcSwcFhMIR
         JKDylycISpuLqnE2AjiF9uX/PnfXyuKkUaUaxYaemG0JzYk4KkeK4NknXThr2sFa7CLz
         qJsQ==
X-Gm-Message-State: AOAM533oM+bSC2S18WDaxTFxzGWwvohQIviaUNuQdVaTQn6ro7gqaCow
        m6mtmX740UhKrU6p9PPAoAteI0Ij6alBYw==
X-Google-Smtp-Source: ABdhPJyMSHVbGUlnI+ksH0i5KKH5OaRfG3l2CB2r+40/zUdgZss34GaHA+uybo9Cvr0batxekUIFdg==
X-Received: by 2002:a62:3204:: with SMTP id y4mr5895550pfy.50.1595542585618;
        Thu, 23 Jul 2020 15:16:25 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t1sm4116360pgq.66.2020.07.23.15.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 15:16:25 -0700 (PDT)
Subject: Re: [RFC][BUG] io_uring: fix work corruption for poll_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <57971720-992a-593c-dc3e-9f5fe8c76f1f@kernel.dk>
Date:   Thu, 23 Jul 2020 16:16:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/20 12:12 PM, Pavel Begunkov wrote:
> poll_add can have req->work initialised, which will be overwritten in
> __io_arm_poll_handler() because of the union. Luckily, hash_node is
> zeroed in the end, so the damage is limited to lost put for work.creds,
> and probably corrupted work.list.
> 
> That's the easiest and really dirty fix, which rearranges members in the
> union, arm_poll*() modifies and zeroes only work.files and work.mm,
> which are never taken for poll add.
> note: io_kiocb is exactly 4 cachelines now.

I don't think there's a way around moving task_work out, just like it
was done on 5.9. The problem is that we could put the environment bits
before doing task_work_add(), but we might need them if the subsequent
queue ends up having to go async. So there's really no know when we can
put them, outside of when the request finishes. Hence, we are kind of
SOL here.

-- 
Jens Axboe

