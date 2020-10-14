Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5515E28E78C
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 21:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgJNTxm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 15:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJNTxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 15:53:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC08C061755
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 12:53:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c20so441313pfr.8
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 12:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vhzO2C2lJxsLCpiO5/5ODRidX2cEq//JC645AmC5yY4=;
        b=YtE+B9bm+PcjPdCWVtDZigdeLmW+2PCshsr+NOjesF39E6DV6IhTsqFPU14PbsaKHH
         D0RuLKpqpWOF94Hxv7TRkDiqaFItaq9QkEOEs8B4WnURamezqQW9tHwBe8fNxsZBccoJ
         PdKnj9Csb41BZZUDfkOYDXtWtXvnNSUKsm3jvoDz5YahUD6wRJuAxjgesrye3N2AwNK3
         dqQm4smIkfF3ARDoBf0RHkuxSTYMPdvPuP0kwybXbe9NyAiNY4K4k6DRrgVvkV34VWMt
         JzqShX5gU64MueHqLjlPU0tmXRE/3tHAX0DQh0CLFdI03EENvmilrmuf6eUs53IdA4wm
         ZfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vhzO2C2lJxsLCpiO5/5ODRidX2cEq//JC645AmC5yY4=;
        b=r31vX3nObXPQgtdmsxefyeWgqMlHeAKlxQhe1xVLQbeIRboruG2NjOOLqSWBbXSFlC
         6yva/D2mqk2KNAWfVMTVxN1diNIxv3Quskn/U3YQ3DWXcnxJcuV/b8U/dnFsLBCTKPTq
         BTIiggMCq6jrl5uSPo8GuwipCX9T+KotxCVODsANQaKQsPiOiIs/icQkE7kQBVryu0St
         hChKnU7mYu1mon78dcocrNVPqaR5BZPONVaXk+QJf9yBQR1zE1A0GlVD+LbuzdKNnsan
         ZThADFL6lcko87arhHoMfFysW5lBA+lOTLTYBG2ncscJXhspT5qn51xnicFxykHOXU5E
         807w==
X-Gm-Message-State: AOAM531I7zIpUKo+uMIrzozIjI8XUMmBECZ5T8FLdqtN8MTmesUF+/MJ
        oYylxknQxwI0Iy5YzfjNO44cbel2qOoqgeRR
X-Google-Smtp-Source: ABdhPJyEn/Q90m3888TQhNLDcd2oH88ZP7ftMUElQ3WoX90mKECOwt1QDqrxPgdVEF9JIYqC7hNqVQ==
X-Received: by 2002:a63:e61:: with SMTP id 33mr462726pgo.394.1602705220914;
        Wed, 14 Oct 2020 12:53:40 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u65sm453582pfc.11.2020.10.14.12.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 12:53:40 -0700 (PDT)
Subject: Re: [PATCH 0/2] post F_COMP_LOCKED optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1602703669.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ec396af4-d2ec-81d9-3ddd-4d66f22bbf91@kernel.dk>
Date:   Wed, 14 Oct 2020 13:53:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1602703669.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/14/20 1:44 PM, Pavel Begunkov wrote:
> A naive test with io_uring-bench with [nops, submit/complete batch=32]
> shows 5500 vs 8500 KIOPS. Not really representative but might hurt if
> left without [1/2].

Part of this is undoubtedly that we only use the task_work for things
that need signaling, for the deferred put case we should be able to
get by with using notfy == 0 for task_work.

That said, it's nice to avoid when possible. At this point, I'd like
to fold these into the last patch of the original series. What do you
think?

-- 
Jens Axboe

