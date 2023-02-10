Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8269163D
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 02:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjBJBbc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 20:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjBJBbb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 20:31:31 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640555DC0C
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 17:31:30 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id f6so4899362pln.12
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 17:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1675992690;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKcbLZcajSuwCxPytCg/HAwDqNSvxwjiKjN+WJdXM3g=;
        b=BAKqWeyRJX/+CY+ycAQS2hXu8QytXTXV+i3VkuadzLhc7RGEJL6UkxkZrXEKeQ6kzk
         gGDLsuqZ56HvZ+XuYcF77BUUm6zKbpXjCm4nSkw4jyDBsjJZ8elQqizmSUfhwen+amqY
         DoTdMSgSKIVOwCrSp4yst55eyrdtZjpzxw42ZZurRdfi+N3erUFSJvBxBnLgthhV65lG
         kJIWyjuaKdzuFxvrDe0iOicgv3LaU4Vne4Xhp7+QfXsD8fMsh19RHPHTtVMhWl4nqx/3
         LMd9KjAY7n2vxFeYcqmq3dZpRB9I/wrdHhMDPMxsT9kscD3loycPlVkPI2xLhRfGlsJy
         0IPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1675992690;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKcbLZcajSuwCxPytCg/HAwDqNSvxwjiKjN+WJdXM3g=;
        b=JJ+KXaUuJDRUXCFH2gmA/6Gb3OADuFdP0SCw2uXL0oNhbReOuEBbzOMwT06Sa6KJpo
         4y88JrodQkMgp1IVV12QJKINZsGmzBeI4bGJ3YiJ/d6RGeqJKpglmeqlvkeh7/deajTQ
         c6v55KSQuqcMKnCHL2RLKCvP5wLlc0o7GP73JlERlNT2Yn+pM+cV24RmNXLqAvPM5znO
         NxVyuwFn0FhcqFrrIlyk+Tu5SOAVlxJLk4G7ByGQ0zW3u34+eLzWUcZJMkJrT6crP2Pn
         XpHQccQOPUu5ElEO8S691CjFHuE/f2NlGDRFPTTdqukM28JDZxGbYc6qhreou1sPJBt6
         vDXw==
X-Gm-Message-State: AO0yUKVclwnKnx8FuAiPUtNpjD72yOrvImsaZBehKo2FzABFmG3Izlrx
        lB9VnqL2nfhdJTvkPAzwgylI0w==
X-Google-Smtp-Source: AK7set99OWZLTEdTRryLAUM9mrpC/FpDRs/UP6g9WHC2xNlVnsAjXH0cTPo+W6bHzuzPoRsWBfmCCg==
X-Received: by 2002:a17:90a:71c5:b0:230:9ae4:b5e4 with SMTP id m5-20020a17090a71c500b002309ae4b5e4mr5195710pjs.0.1675992689827;
        Thu, 09 Feb 2023 17:31:29 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a550800b0022c0a05229fsm1981832pji.41.2023.02.09.17.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 17:31:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
In-Reply-To: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Message-Id: <167599268879.12300.18198007262515314785.b4-ty@kernel.dk>
Date:   Thu, 09 Feb 2023 18:31:28 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 01 Feb 2023 15:33:33 -0500, Richard Guy Briggs wrote:
> fadvise and madvise both provide hints for caching or access pattern for
> file and memory respectively.  Skip them.
> 
> 

Applied, thanks!

[1/1] io_uring,audit: don't log IORING_OP_MADVISE
      commit: 2bd59885eb9c2094d118b4321d5f74e12e77ef0f

Best regards,
-- 
Jens Axboe



