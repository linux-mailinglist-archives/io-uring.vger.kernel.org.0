Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EFC42013C
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 12:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhJCKqB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 06:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhJCKqA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 06:46:00 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6980C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 03:44:13 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 145so11984964pfz.11
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 03:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6lNjwNRbHusJGXX8fgXx2oOkUuU3bA88UONhhWIcXaU=;
        b=JrhX3XjrgFzzl0xF6fTvRfuK3mMMIQ+1+5LwVCLlQSti5hCtabTfZetgpGdNcs3Z5H
         Yfhv+teg5RKOgnypqTj1rTKmzKc3jWhZgLHzQSuy+9mcrHGO/NZCiKYW4i1MDTDFtk8l
         e6zQ3c+PnxHfg6vyRsmwtQoq2ao3wFpc1OZ4GsZJG1KfkzFPMBOYhwyG/HtQfMZQ8Ns4
         ybaBVzVKIWm+0Lfw8UzU5D/P2aSuTRrE9ZO24x8DK5DkAbK6LtEvxCNnEv5l18JOVKaV
         U+P4DNrq4WFZJPEV25hJQb4qdyxmh0YxX6MQFdyT7FF0IYszNeZpRQtrVYGKz37hwsDN
         kd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6lNjwNRbHusJGXX8fgXx2oOkUuU3bA88UONhhWIcXaU=;
        b=iuUbzzjRj5l0kCgcNYy8zWjCKrRXG0zf/1KDrGXwInZg2UNoriTC1YcFUdaWcwDo9O
         Joqjp4VJU2RIDsS/SIp1dFvYjJUM002fwhsJCgZ49rob7JGhckWlmKllg4mpNbQOBVTu
         1BwgoE8cUwrmWTyU19WDGs6RjNMwuS13GqAf2b16EQuogwyGbiWj1XbCFyZIKjOLzkS2
         4YmeQ6KuJi9LOy6yhQvig11nQRbnYJmNXjrPBB8HMP7b+edWNpvTcWMTq3AiP8fOPaEq
         V8jDfD2tnKTpzMdbOcGcq6f5wAw2VR2E83VcpHxIEr3AFv4NjLNLqSkBdv+zo6z8lFeJ
         xxQQ==
X-Gm-Message-State: AOAM530u1G/gqFkGr0YJH2Lt01NlbL7vyBtR6NynU8HCDrCaClFjq6gh
        x4QIg2KLUV2QnFhpIOTFs5C0Sw==
X-Google-Smtp-Source: ABdhPJxkOEpFuOLCISKO/cttpZVbj6qK1RzUvVGeD35ug2WJ9L4G1eAzvQcWDRNfHUFeaz7ML0pvYQ==
X-Received: by 2002:aa7:80d9:0:b029:2ed:49fa:6dc5 with SMTP id a25-20020aa780d90000b02902ed49fa6dc5mr19482909pfn.3.1633257852505;
        Sun, 03 Oct 2021 03:44:12 -0700 (PDT)
Received: from integral.. ([182.2.36.212])
        by smtp.gmail.com with ESMTPSA id e7sm11635146pfv.158.2021.10.03.03.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 03:44:11 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: Re: [PATCHSET v4 RFC liburing 0/4] Implement the kernel style return value
Date:   Sun,  3 Oct 2021 17:43:24 +0700
Message-Id: <20211003104324.177341-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211003101750.156218-1-ammar.faizi@students.amikom.ac.id>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry, wrong subject.

It should have been
```
[PATCHSET v4 RFC liburing 0/3]
```
	not
```
[PATCHSET v4 RFC liburing 0/4]
```

Apologize for that.

-- 
Ammar Faizi
