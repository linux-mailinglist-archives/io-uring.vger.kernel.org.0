Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C089474DBDA
	for <lists+io-uring@lfdr.de>; Mon, 10 Jul 2023 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjGJRC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Jul 2023 13:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjGJRCZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Jul 2023 13:02:25 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB78BC0
        for <io-uring@vger.kernel.org>; Mon, 10 Jul 2023 10:02:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-682ae5d4184so1016628b3a.1
        for <io-uring@vger.kernel.org>; Mon, 10 Jul 2023 10:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689008543; x=1691600543;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=twIKQ2MHmWju5IY9XdGeqwYNLAm5VOVmCmH1cwAeJvk=;
        b=sprGqyuTIkmhlp/iXd5gmNH66qzxiDBk8Cam7K03v2kzxqK9/AFYFQvGhIE1D4y/PY
         mgSHU0aplUx66upCzdNow5DVpTrfAY2q407OHNIoA+nTIyH3oMpGtxM8Cb3gIHwlGpWN
         l6v3kltpBon+nO1yEEILHeHPbORVFoQ6qJ2DwMiqvrNWHdwr3LAJtsr0xoTCAyloTuR7
         5VekZ5DWDlNYCoXiZc6B3++nUd6Pxl4xfJFwEGeQX5hADWaGGbYzlUl5DSYc9B3CROP4
         kxkNeIbm6TmTeZDMzQo4TSmhUXqz9V/lVHLrEpjVqIqdIvjfLg0XDCVu+4kkSWpW++Kp
         FT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689008543; x=1691600543;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twIKQ2MHmWju5IY9XdGeqwYNLAm5VOVmCmH1cwAeJvk=;
        b=NVku0A++RS3Y6/xdTi4/XfAg+XsWBMex3n4yHlTPUAXez7XY6Gu95cizMsw97KuHgl
         OKtMqZ1fRbNh+fbsmPSW49uDkRiJo1MCaZvE33RMsOVBSQtK3lY+N/hCH2m1EhnntIAs
         Z1/Vdi4qT6QSiL1IyWY7ON5KSvcv5Cz+XDlfse/GQelyyPql65COxXDPJrjVMP5BTd4z
         0xMWis1lUok8I+yPlZMo6d5YyEn1GgMgmQOoPeCU7aOY1k+scq1ZN0Y3ZXgTmh/0flsh
         SP1+0gckVNSg7S77eO6+jpSHSJdq++R/BonuMlL2sfxB/6fr75yweyllXFSBpWf2J5cj
         f8+A==
X-Gm-Message-State: ABy/qLZWBSVoGjIfcUQ7gXdKujTe22RGVXzNFigW53Rzb7EAg6wAiohP
        ZC1sYjS1MWtx5TJ7IJLwS9b6lA==
X-Google-Smtp-Source: APBJJlHedqKsKuyUaPZ0noHnVu/heeqrZZBf1PjMGnOYJMAaqmONjhnkrTFZWY2hVKZgNlfBPFnRDw==
X-Received: by 2002:a05:6a00:3a2a:b0:675:8521:ddc7 with SMTP id fj42-20020a056a003a2a00b006758521ddc7mr15664306pfb.0.1689008543234;
        Mon, 10 Jul 2023 10:02:23 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a17-20020aa78651000000b006828ee9fdaesm29514pfo.127.2023.07.10.10.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jul 2023 10:02:22 -0700 (PDT)
Message-ID: <7e8c910f-4938-01c2-ac38-7ce89236cec1@kernel.dk>
Date:   Mon, 10 Jul 2023 11:02:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] io_uring: Redefined the meaning of io_alloc_async_data's
 return value
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Lu Hongfei <luhongfei@vivo.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
References: <20230710090957.10463-1-luhongfei@vivo.com>
 <87o7kjr9d9.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87o7kjr9d9.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/10/23 10:58?AM, Gabriel Krisman Bertazi wrote:
> Lu Hongfei <luhongfei@vivo.com> writes:
> 
>> Usually, successful memory allocation returns true and failure returns false,
>> which is more in line with the intuitive perception of most people. So it
>> is necessary to redefine the meaning of io_alloc_async_data's return value.
>>
>> This could enhance the readability of the code and reduce the possibility
>> of confusion.
> 
> just want to say, this is the kind of patch that causes bugs in
> downstream kernels.  It is not fixing anything, and when we backport a
> future bugfix around it, it is easy to miss it and slightly break the
> semantics.

Exactly! This is also why I'm not a fan of patches like this, and was
not intending to apply it.

> That's my downstream problem, of course. But at least it would be good

Strictly speaking it is, but I think we have a responsibility to not
have core bits be different upstream "just because". IOW, making it
harder to introduce problems when backporting.

And fwiw, I'm not sure I agree on the idiomatic part of it. Lots of
functions return 0 for success and non-zero for an error. It's a bit odd
as this one is a bool, but I'm pretty sure it used to return an actual
error and this is why it looks the way it currently does.

-- 
Jens Axboe

