Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10717A22E1
	for <lists+io-uring@lfdr.de>; Fri, 15 Sep 2023 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbjIOPrY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Sep 2023 11:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbjIOPq5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Sep 2023 11:46:57 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972052126
        for <io-uring@vger.kernel.org>; Fri, 15 Sep 2023 08:46:11 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7748ca56133so11228239f.0
        for <io-uring@vger.kernel.org>; Fri, 15 Sep 2023 08:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694792771; x=1695397571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iwcgknpz61+feiaewZgxs1TindefcX43o6hE9PAUxNY=;
        b=NtRwuUWjuQoO8+26/TXJ/CqWF3k1uZRcjViZ/wI8KYnKb+prX1Tt7UYC/ZuhiglMng
         0OgmL6npfwqg6QbJC6SLCMJyMmC6KowwK2w/e3E0wML+WteiU0HIndEm8ezoKQoijw40
         vMoxSUuOGQBSsKPf49wfv//5QmmD8Yo8Pka5noH4rj3TTLh2nOtoMI4iQDva5WljAJvO
         y2eiaXKwlJna4OdmjPbWne/ENvKVz3wbR5wpVVwYbvvK5WXFTPV5lRBGIlyVA5ggxUsy
         I+m20q82RvmlRlcAWxhB2gOxnHXcmm500Cemu+vDMEKV+2PROfM3G8Cjt0T7MiXEX4nB
         rYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694792771; x=1695397571;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Iwcgknpz61+feiaewZgxs1TindefcX43o6hE9PAUxNY=;
        b=trQHbWqevde0ZSHD4N7FLp++vsNKBfTg7gc1vwLSGdNRXrbaWH/Auve1naaJPhNheC
         5d+/3p137Ak4rPMoPDStWjURlpxjfuAT4i9P+R6FEgphP2PVV3KnAAqxghrnf0zH+ePE
         FcPHIyYY3YNrb1r5S+fwzOk7AQCCL2vo/Lh8pC52ffbOUlkkhDg0Zbs6Ne9op5tN8LyJ
         08YvL0J2nAvuXxL74tgUg5UBxn6mb/3l2R39KM5sf+Ui8ClqsGC1PMuA//utqTvkSC6p
         uUoG/djnNRLVqSuKzgPNq1fGyZsVEfeQ5fDP6n08yZ4uwnkHEGLJcIXhbSp1jolmtBz/
         XC+g==
X-Gm-Message-State: AOJu0YxKvkVFMYwpdVwcsbKS+s87/F4CSczQ4pREq7hwwJeiFcwH/hR+
        7tBMM8C+AdS6ptS7BPs/38qD04l0Ux7wRRHC/pVZtA==
X-Google-Smtp-Source: AGHT+IFgMdlpmYfsEzjx/ygbDe2BwxPxiuILWz2gHqUWzdey+FxHs9bx2kbNm1mb70QlRUwlqueang==
X-Received: by 2002:a05:6602:474e:b0:792:6be4:3dcb with SMTP id dy14-20020a056602474e00b007926be43dcbmr2189988iob.2.1694792770784;
        Fri, 15 Sep 2023 08:46:10 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e24-20020a02a518000000b0042bae96eba7sm1119917jam.7.2023.09.15.08.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 08:46:10 -0700 (PDT)
Message-ID: <736453bc-ad55-422d-87de-39e1439a12e0@kernel.dk>
Date:   Fri, 15 Sep 2023 09:46:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.6-rc2
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single fix, fixing a regression with poll first, recvmsg, and
using a provided buffer. Please pull!


The following changes since commit 0bb80ecc33a8fb5a682236443c1e740d5c917d1d:

  Linux 6.6-rc1 (2023-09-10 16:28:41 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-15

for you to fetch changes up to c21a8027ad8a68c340d0d58bf1cc61dcb0bc4d2f:

  io_uring/net: fix iter retargeting for selected buf (2023-09-14 10:12:55 -0600)

----------------------------------------------------------------
io_uring-6.6-2023-09-15

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring/net: fix iter retargeting for selected buf

 io_uring/net.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
Jens Axboe

