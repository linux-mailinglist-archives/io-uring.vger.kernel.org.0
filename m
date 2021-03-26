Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FF134AC15
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhCZP4Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhCZPzy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:55:54 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DF5C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:55:54 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z3so5850358ioc.8
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=htT9Qs8sIEoDcG98AlHfNLII3VyCG/lM/ZLYO+IOgWg=;
        b=Uc0lsQPzLIgro4HFNFVjc2lZnhSUaU9qB/kKfcjMmfH1tknq0ku0J1OVO8YViW7ptb
         enX1zXuboQKV+uT1f2+Ri5SAXygTY4T23RCLhBVEYhQCqn5ZvDsQWTzn/5HK1DvCVSyo
         OCCfO6PvzjDFfkVB+2glWszP1/ej3AmJwn3sSSdJPYToJdIA//tjiJAdiQQ6n0YCs8ew
         uT3V4B3WOQ5mScQFa8PYMSCntOk1Hi6hfHtrFqOrBHXk2qM6G8PhsPZkqJ9tYhJnYOzM
         mNTbOYFvFPei3AoK748VUXiOvAuiWkO8FhqzX1svK4j+eu8L+NQtprvMcGhqOH1KWlU1
         exZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=htT9Qs8sIEoDcG98AlHfNLII3VyCG/lM/ZLYO+IOgWg=;
        b=rfixybkWTMA2iO6Kh9EyZMq6ao+NboBffzsastPcLZV6NZPgRWCqbd+Rt/olU4Z1R8
         VNN13YaWQXo+pQpz4GJljFL31uSMGd1bcT9RDZY0PMD9r4+PwVfKxJ6p3VtNh2PsuFn8
         cQpKt5DraTEI+aazydR2cAeBmKVzDpqJzNiRNds6SDqj5ZXRBVCWNsed1nr1W3nt06/T
         nBRy6RGUbk2Bp0NkM3PsTsJJBjJ8RoWhfzkCcVoXc2RsTDGbpv0cfiNJOBjaj+GzuyJe
         EySYa6aJkTAQQrWoywogqyFfPQBI9T2AStlA28n+5dWK/yrMYQN1ytp8bouLvT0dJbci
         Y1sA==
X-Gm-Message-State: AOAM533/s84yc1TIOLpi8Bk5kUP4dWNVXDRi/so57jeq9f2bNm9LDfpP
        Sw7KfAIN1DgQwBo8gnhXiyf/uZWAhIumzw==
X-Google-Smtp-Source: ABdhPJwBzGrskoS/4FBNUj3TnfHqOeIOxQvxMJ9HDbu/dcdCSYQ813HGVT8UVEYeQ8h80uoeyR4Kag==
X-Received: by 2002:a05:6602:1649:: with SMTP id y9mr10562113iow.209.1616774153259;
        Fri, 26 Mar 2021 08:55:53 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k12sm4423443ilo.8.2021.03.26.08.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:55:52 -0700 (PDT)
Subject: Re: [PATCH v2 5.12] io_uring: maintain CQE order of a failed link
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b7a96b05832e7ab23ad55f84092a2548c4a888b0.1616699075.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e15c1ef0-9ea3-6542-5c25-cfe97c2b1a59@kernel.dk>
Date:   Fri, 26 Mar 2021 09:55:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b7a96b05832e7ab23ad55f84092a2548c4a888b0.1616699075.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 1:05 PM, Pavel Begunkov wrote:
> Arguably we want CQEs of linked requests be in a strict order of
> submission as it always was. Now if init of a request fails its CQE may
> be posted before all prior linked requests including the head of the
> link. Fix it by failing it last.

Applied, thanks.

-- 
Jens Axboe

