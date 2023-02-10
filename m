Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4387B691510
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 01:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBJADA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 19:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjBJAC7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 19:02:59 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E227D552A8
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 16:02:57 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z1so4757022plg.6
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 16:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q8RgkYF3JC96fmCLwMJitTdP/XQYABepAo0BCzA2V9M=;
        b=DAmhh8JZz3adu44KPpEAgp5QKCI9r4ZBL+xL3LfYyCyOo/frtkEz8ReOJ4g0KFg7Er
         /X85mON5yRxtp5KIacNo6T6RnbN1Mgxjq6Z8xRn3Rgv1+3KveUpp/y9PW9mvAWGDyOgx
         z7S74xfEdXgErIJ/5AGWapnaZE6fMzSa1cnONWxbH9id1QlrwVs8N0YGcUraH3RIJgbl
         woP/1zzVdqam3TpOzZxUcn9uk6B+UjfXJhxx8ifIUaAiQKsrpvi3WqK3RLV6ychlXOJJ
         fjzvaGpvYYDQchCXfW70WzXV1tswUI+ULgeTEiCeWr3ZUVlcPe7aUSHflCmgvggD9gGl
         5oAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8RgkYF3JC96fmCLwMJitTdP/XQYABepAo0BCzA2V9M=;
        b=fJOkaJZJAN+5ntegu4KrYUNuqUQHkbNWcn+/yBSfEVOQJro/PptMjhm+XBsNR2fhgR
         6m1tugsxpELHX7ZAfN10pRlhdjMhoHUblHlbwhqQ8TF7x52DZj9aad+7Em18rceLsRhq
         +aahhv8t/owe+6VypOIsEHMYFivG0MgtNkwqM2TrmkpQOsWszfrLZ4fELagmdJ7XQdgk
         M3G86iFDtzZA5uBObr8fs4Who4Y/q+f+TForJ42Pq/Okr1T2ssh+aT4tYid5SY3sAEjP
         HQayK0FiTr/oZ5f+DwqfwpG+PJ2ya394wVREPM/5JvIiY5ZvJKpwpYqoitftNBqKk47y
         M15w==
X-Gm-Message-State: AO0yUKUu/VP4dUNxTpKbwAnFp0p164u46YVPbBf4BLKgxEMicfGvMDSn
        AxkwiexCU6vsfrDp4uqWkORe2Q==
X-Google-Smtp-Source: AK7set82IG/bhTktV1qxrMrN7+dDrPWbwNg1EypN7rNVr/X6CVP9E8H4dIVX8haTgrkFIOLaIK7i6w==
X-Received: by 2002:a17:903:182:b0:198:a5d9:f2fd with SMTP id z2-20020a170903018200b00198a5d9f2fdmr14039674plg.6.1675987377389;
        Thu, 09 Feb 2023 16:02:57 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jw19-20020a170903279300b0019a6cce2065sm625602plb.192.2023.02.09.16.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 16:02:57 -0800 (PST)
Message-ID: <e9a5b3a6-e6f6-9d8a-763c-d38fd77a9285@kernel.dk>
Date:   Thu, 9 Feb 2023 17:02:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 7/7] io_uring: add api to set / get napi configuration.
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Jakub Kicinski <kuba@kernel.org>
References: <20230209230144.465620-1-shr@devkernel.io>
 <20230209230144.465620-8-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230209230144.465620-8-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/23 4:01 PM, Stefan Roesch wrote:
> This adds an api to register and unregister the napi prefer busy poll
> setting from liburing. To be able to use this functionality, the
> corresponding liburing patch is needed.

Same comment as for patch 6, and additionally the subject line here
is a dupe of the previous patch while this is not what this patch
does at all. It adds support for setting 'prefer_busy_poll', that
is what should be mentioned in the subject and explained in this
commit message.

-- 
Jens Axboe


