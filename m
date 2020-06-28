Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220C20CA42
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgF1T6j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41032 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id q17so6970515pfu.8
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=onRPODWcntNahq0EdPHd/AApP3En8KZ41/adsw3Zr8U=;
        b=oqDQIukYXHZPIkAa4SC15XeCc21lh8kFZ8pB2zVUEA+upKMN6Lcvxz1m92msa+9YWy
         0EoegkQW3uOEARWjdA0Hfs0RsDyukFoJv47WS5YPBVYlhTAQqtWEIiSYGemKg7Vx8XOc
         Oo9d2ZebvFs22R4TzxewLORMJBgHTlwIfoGV8a2qAD/ldhSuYVoA6m4wtee/Ly5Kdk6l
         NWtvygW9vQ9YEOMZRcgTMcrgFHVyFuTeDAIy6vvrIU8sxm5rYliS4BvVBRxWUzVu4mVn
         3Q5dWVFR6a3M+EI/ONBLHe+mpUU7g/1qS1iuLQWkF4HqPnW1lxYsPPL3+zpYXkdi7RVF
         paaA==
X-Gm-Message-State: AOAM530Ov3duO4gwYPLavtg//OfclOj9F15uRQ5VpdmzgIuyrDijqs3s
        jjrn+gJaus7gKuKbhkq65BbQyYdO
X-Google-Smtp-Source: ABdhPJzNoM6ZOGcmlbiFDId0NN8yy/riGh9VNP263qjv/IAKCqs+QaJvtoOCQ7y/KW5VItjxkIiLiw==
X-Received: by 2002:a65:6246:: with SMTP id q6mr7486117pgv.133.1593374318452;
        Sun, 28 Jun 2020 12:58:38 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 6/7] .travis.yml: Change the language from C to C++
Date:   Sun, 28 Jun 2020 12:58:22 -0700
Message-Id: <20200628195823.18730-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
References: <20200628195823.18730-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This causes Travis to set both the CC and CXX environment variables instead
of only CC.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 .travis.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index 7ed15c7ab142..69da3c07df7d 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,4 +1,4 @@
-language: c
+language: cpp
 os:
   - linux
 compiler:
