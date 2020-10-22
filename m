Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7304E29670C
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 00:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369599AbgJVWXC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 18:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369533AbgJVWXB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 18:23:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BC5C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:23:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h2so1706332pll.11
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TwHuXdlT7Cza/mMEZSjwV4RM5ad6+7cCRD+g7I9ZbaA=;
        b=w2/kYqpQCglHr+yzI3Y9A6Z/Ae1zwwYHRcg8tBONhFYboiYIC68J2viEjcFncgWzx9
         yGCiz6AuxhT3HpsIBpLPLMDZkyGDEZKwpnfRJtOaXTc9vNn/jQoKv45NPmHpUIhzEdCd
         bQuMoD5MIiXB+J5uryztti6CII3H59UDl+2NyTIuHwhc0pEfhpZ+dsL30lryqlL/Rj3o
         owD4LM97v0IcP7Hab4oZMBmu0cxT9vnibk7AfkPzkDhSb/vC4BGTi1GUy6S/TQRdMlpk
         bwkVEhypvweveUE09PZlIB7R3uEpPXWrfVWq6jRZ6nuEGz+x49qi0J7g96EWUN79NZwu
         hDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TwHuXdlT7Cza/mMEZSjwV4RM5ad6+7cCRD+g7I9ZbaA=;
        b=oca2uw1jWZqRFZzyd3xp8TVpZ7L6DxZ3MuCOhTG3CFNoBg5AZ3mDaRwp9bSOxeoOQb
         WmA0jZ/GlOpM1IZ+wYmo7rEC/yIjsaqn7ShZ6UrNJ0Fg3ZHnyZXo5wB02L4pk+oP9Vui
         mRPuzMkaeLy9WWvtgGdVmfsnk915bYiQAqTmQIyu3lx8G7zuM4T/6TZkTD+mAck9qHAX
         muYyX3pWwwJTpFVtuYojD5xuquO4yYvhM6KR/QUDt1ZX59ZsLZz8IiVSY2wXFVcvXz0/
         Mw+vHojGxi+X1XUUU9FL3V5kb98SbkQtTjqXs2ag0pHCAjgBgUPULfx8/4BrONPT4RGP
         k9FQ==
X-Gm-Message-State: AOAM530hBupfomYx6DwCaomld1WITwAa1CMLN91ZnYSL+AeYCg/Jujq+
        wW9Wf8KdsKFiUv1e5RAzpCTaSk9v8Fz2kQ==
X-Google-Smtp-Source: ABdhPJynbUgHJ3XfJOSA+d1m0CSkc5GM+Y+o/NR9/VRzf8O/aGBkPTgxDKQJtjQi5/9jfekyzcua7g==
X-Received: by 2002:a17:902:b604:b029:d3:7919:bb39 with SMTP id b4-20020a170902b604b02900d37919bb39mr4816918pls.78.1603405380857;
        Thu, 22 Oct 2020 15:23:00 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w205sm3332194pfc.78.2020.10.22.15.23.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 15:23:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: Fixes for 5.10
Date:   Thu, 22 Oct 2020 16:22:54 -0600
Message-Id: <20201022222258.61124-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

- fsize unification with the flags based setup
- NUMA affinity fix for hotplug/unplug
- loop_rw_iter() fix for the set_fs changes
- splice fix for the set_fs changes

-- 
Jens Axboe


