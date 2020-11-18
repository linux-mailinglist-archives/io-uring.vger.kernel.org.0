Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7C42B864F
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 22:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgKRVLV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 16:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgKRVLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 16:11:21 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6CAC0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 13:11:19 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id d17so3621460ion.4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 13:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UIRRERGYEFW1YuTYDXiJXGPhOeUxKqCH1iLMoXDyh60=;
        b=bg/QFXmwM76CeN8/JtyPC3b1uDe/a85+YGEmHh4fCyCb1/2fP/ReEP+pqwPFaCHfcn
         xI686V22audU3bnVuwieOWm6fiZC6GUB20ZcsOxmksB1k0AGL3ku4/EuCWgVe/ku4g9o
         zSINcE/eqqoGxvy1cxjMlh++KbouXyTY8BUgy/FmqpO615x132iqkxTaYhnHdM430qv3
         ERMRoNqCFqD465OgqFxlwNrCirc2EYaJJEIqHb0Je3AmX7vbaW7Ijx3T4rIdbhgOmd+r
         /hFuEKB2O1QXoj0gsJpQpGMOCOhrLrlf3c5p0ojy9f1r4Weo6qDbm7aaiTNONLXO4f3F
         jvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UIRRERGYEFW1YuTYDXiJXGPhOeUxKqCH1iLMoXDyh60=;
        b=bhcKoLNu2KGw654YcQzKHlIQ8yqA8nByQsVpwbMAE1vLKmkZy/YRQH+8GyVCZAtGOu
         1VLGOrkWrviLOM0lBgld9KwWaSrzGIusK2sYmUSDkiwja6AyklK2ffoNOAf8gskcT9k8
         wHEwFAjRnoCUn9w8cWDUPizOeqcV5yNZoXJJFSBWfc80KHwdvgSAIXdStRzgvmNw26s3
         tpILm3KOTSIJKolHkFj/KoVjwCGko8qTuSyMiuDzpeEh5vSNCS5GVKX4iGhPs7tLCdSS
         RIqcDPLbrJgMprnVfT+WTlZ+R5CBggU9dtRpeK3TQDRrB3EOIer7Q6pI6RFzil+4O3YE
         fjdg==
X-Gm-Message-State: AOAM532Io2tnCgVgIsCwMd37u+74/oq6caWL0BnNjLqD4VWK2EhhX3bs
        AnIDzmKLW+m+abyrywT3C+Y1b0K2bjXQmw==
X-Google-Smtp-Source: ABdhPJyD5FwUsEi5E4ANWY/4DSHLySyE32BdGZNR5u2bklzogRMhsUs8lghUE2xLOa1ACbbMnHwSEg==
X-Received: by 2002:a6b:d801:: with SMTP id y1mr17482240iob.61.1605733879022;
        Wed, 18 Nov 2020 13:11:19 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k20sm16017842ilr.28.2020.11.18.13.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 13:11:18 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: share fixed_file_refs b/w multiple rsrcs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        bijan.mottahedeh@oracle.com
References: <cover.1605729389.git.asml.silence@gmail.com>
 <b5c57cd24e98a4fae8d9fd186983e053d9e52f37.1605729389.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f4e72558-56d4-8036-a6fc-65b46201ed89@kernel.dk>
Date:   Wed, 18 Nov 2020 14:11:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b5c57cd24e98a4fae8d9fd186983e053d9e52f37.1605729389.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/20 12:57 PM, Pavel Begunkov wrote:
> Double fixed files for splice/tee are done in a nasty way, it takes 2
> ref_node refs, and during the second time it blindly overrides
> req->fixed_file_refs hoping that it haven't changed. That works because
> all that is done under iouring_lock in a single go but is error-prone.
> 
> Bind everything explicitly to a single ref_node and take only one ref,
> with current ref_node ordering it's guaranteed to keep all files valid
> awhile the request is inflight.
> 
> That's mainly a cleanup + preparation for generic resource handling,
> but also saves pcpu_ref get/put for splice/tee with 2 fixed files.

LGTM, applied, thanks.

-- 
Jens Axboe

