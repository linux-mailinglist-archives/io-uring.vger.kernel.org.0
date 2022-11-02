Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECBD6164DD
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 15:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiKBOTc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 10:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiKBOT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 10:19:26 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125F629CBC
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 07:19:23 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p141so15117105iod.6
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 07:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OhGWJNs7iCNLMBzsE17HPJz7UkwDp655tCD+1lEhzfE=;
        b=hMu6n9vkuRJZnh433CKgeSPJk2DLXzpvm5YyWfG6Dezh8scTxtX+rFl6G3soNSEVyX
         ebNH7Vf8pua4Mlbu0LQaKUpFMP98uIyyTDkR+dp0GbPnJlLpKMVgkiQtD1k8uwln9EU4
         RhwC78kdb6NBOPJjpbwrmxdehbfB0xSShSGgqcyGPeON/uauEkZQHyrKs+WWd4Lg3/GF
         R1bOvD3+MbXv4JOWwCKtYYNSMpgxgABPgQusLv4Ynjk76wvVZnM4r0yItdgOE2teEwrd
         rNQ8DVZQhDz/WuLD2/BxvjcA0d+nzLssQ4ePyZfzpYIpyIfMCq+tDGh7FRYWvaMGLH8j
         LGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OhGWJNs7iCNLMBzsE17HPJz7UkwDp655tCD+1lEhzfE=;
        b=cUJV2r30IqRU4Z0b7EaEacHqjiYn71Aej1ngbMB6d/6Cj7/vydbURzbsTQS+TAY3Ha
         m6ILKZEyMwA0KUUyzuT+OWNQICmQYc2OZ37mSX0xpCCb4qQBIfBIsZB81mKk5I5HMKSP
         iZPQA1UfrAThY6cCr48kDFIrOJr2wu6V4jB8KAzyUx6Vwx0ChIj47mPaX5tO+OehoUgP
         dWVYEBYbyQmPckHtm6+VETo70YrkbF7cqpJGH5PmyiJ9noa6EqQ3LEWXxFxyDMX2erVY
         7KF+Iz2Nh4+Z3ZbcgEfCStYjW4d8P78+EUen1TGgUmXwqF4lZBFLGte2hzuE/QAKRGwj
         mseQ==
X-Gm-Message-State: ACrzQf1O6UUv4Buiv38PM5qlfNzApiXf2RePSpzDN5dOrzlLGEuvn5DK
        UIB/Y8GOO49xUF+WqZFUvQ4vmKbZRdJYvEkm
X-Google-Smtp-Source: AMsMyM6SGUp1Hp+A/FPGcXgi2Pepu6EVOW+1KGrHyhhqlYXa9abmqKdUVmHeIIdF8mc2MHFrP+nugw==
X-Received: by 2002:a6b:3fd5:0:b0:6d0:b601:a48d with SMTP id m204-20020a6b3fd5000000b006d0b601a48dmr11498402ioa.20.1667398762220;
        Wed, 02 Nov 2022 07:19:22 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f24-20020a022418000000b0036ce87bfd0fsm4790264jaa.98.2022.11.02.07.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 07:19:21 -0700 (PDT)
Message-ID: <630269a9-29a3-6b75-0a67-449ec36e7e5e@kernel.dk>
Date:   Wed, 2 Nov 2022 08:19:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] io_uring: fix two assignments in if conditions
Content-Language: en-US
To:     korantwork@gmail.com, asml.silence@gmail.com
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Xinghui Li <korantli@tencent.com>,
        kernel test robot <lkp@intel.com>
References: <20221102082503.32236-1-korantwork@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221102082503.32236-1-korantwork@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/22 2:25 AM, korantwork@gmail.com wrote:
> From: Xinghui Li <korantli@tencent.com>
> 
> Fixs two error:
> 
> "ERROR: do not use assignment in if condition
> 130: FILE: io_uring/net.c:130:
> +       if (!(issue_flags & IO_URING_F_UNLOCKED) &&
> 
> ERROR: do not use assignment in if condition
> 599: FILE: io_uring/poll.c:599:
> +       } else if (!(issue_flags & IO_URING_F_UNLOCKED) &&"
> reported by checkpatch.pl in net.c and poll.c .

I'm not super excited about this patch as the previous one
wasn't even compiled? Did you test this one, compile and runtime?

-- 
Jens Axboe


