Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BECE7B99DD
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 04:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjJECSc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Oct 2023 22:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjJECSc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Oct 2023 22:18:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F95C1
        for <io-uring@vger.kernel.org>; Wed,  4 Oct 2023 19:18:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-273e3d8b57aso107420a91.0
        for <io-uring@vger.kernel.org>; Wed, 04 Oct 2023 19:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696472308; x=1697077108; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nylsPv01FhcIQ1fQCWFaZjgpHC7pMUtkl+BsAd/AlOs=;
        b=z5d+uGgixlSezf4dKOIom//DlBhpmjqr4VTM3HauaIfwD3tCGHbPwEGZWINzi35LIL
         El1k+wxq1bT95b4MfC9vQ5eNQ0dxD56N1N1U4tXvYKJ9eZyzzSSYGihejMTJeUld+6mr
         J0U31VuYI7QHsvjT5/CqrJ171RDZgLl2aDK+1kf/ZhX69hVaWVi5TKa7Ms9mfdlVWGzF
         p2nWGm1pn4u5fMZ6X2ujM64M3FGrBOA/wJfGnyjlV24imBx1oZia3b/wP6AplwO8u+Zt
         6LCORSFuXPNmBZIje9qEjH16F+vkKG9Wyk8yI1MjInEH93CF3S9doRDLZCMc8txzp/0U
         3Hqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696472308; x=1697077108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nylsPv01FhcIQ1fQCWFaZjgpHC7pMUtkl+BsAd/AlOs=;
        b=o8BcNyisCKZ755XCPm0gTnJo6AfWWBg1hVS85cXw/hgWh+PY/7ET+E+jddR0QamAr5
         Wqa/H3u7NvK3j3e3kam92EjI/ehlHAJgtQvptOFo3FzZbGSvUOEPxrFG7b8i7vu6HE1Y
         DO7BTEvvNf+gFhMadvPVhYfXbBosMmnnzcO8slaRxasdk4gfM34Wqrp51/CWpeOzRr0t
         R9lIbzXY7HELSmn1X0zSkN3KhgHrIzC+aQ0Ymh8czqVXiEe2Ioh3z+g21mJMjkSHXpdT
         9qeJ8u4Q5tJ04bOKSr5UGp0lX5dDEHl+qy888XxLA8jZOqGZeVzq7jyL78RiWAKKPQ8N
         JHEg==
X-Gm-Message-State: AOJu0YzW6TAW8EIFPbU8YYk+B3T3Z4+wpxP7qlT6/0fxXBgYrkJAsHqs
        LD3qAq+FH1YjeDMDJy40F/S970NtWvVzfke7lps=
X-Google-Smtp-Source: AGHT+IHbXFMxqaYA/pTZeZxnR5rXBbugdp5k7efZqDLkefyOODr6KZEGE+olyhzT0HzBWJGobsg0Gw==
X-Received: by 2002:a17:902:ea0c:b0:1c2:c60:8388 with SMTP id s12-20020a170902ea0c00b001c20c608388mr4194528plg.6.1696472308224;
        Wed, 04 Oct 2023 19:18:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902eac400b001aaf2e8b1eesm268705pld.248.2023.10.04.19.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 19:18:27 -0700 (PDT)
Message-ID: <2b5d884b-9709-4219-88bc-47840f62ff46@kernel.dk>
Date:   Wed, 4 Oct 2023 20:18:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] trivial fixes and a cleanup of provided buffers
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
References: <20231005000531.30800-1-krisman@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231005000531.30800-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/4/23 6:05 PM, Gabriel Krisman Bertazi wrote:
> Jens,
> 
> I'm resubmitting the slab conversion for provided buffers with the
> suggestions from Jeff (thanks!) for your consideration, and appended 2
> minor fixes related to kbuf in the patchset. Since the patchset grew
> from 1 to 3 patches, i pretended it is not a v2 and restart the
> counting from 1.

Thanks, this looks good. For patches 1-2, do you have test cases you
could send for liburing?

-- 
Jens Axboe

