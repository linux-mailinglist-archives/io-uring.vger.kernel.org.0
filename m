Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450204216EC
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhJDTFn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbhJDTFn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:43 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077B4C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:54 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dj4so69331766edb.5
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sgvqu0wVnoaMbLm3S8eqNMAkJAM4WCInIMji8pXhAX0=;
        b=F0Lpc8gyEwh3eFCdobPwhEdwsu/0nEQfOMDhyw3Qxhf3P7OGrtmhDvzkvSSWUcI5oR
         roDWNXQiOTcPn7KrEww5f5yvQeoZRi9w2ndLShvY+ES+6+r/T1vNILDy/a51g6xxi0Jc
         kkq/SYrIkngFCejkxOmcQNhCO+anAi3gdc+BBs3hslmZP/VZ/wPjUZXl+3de08P2iUll
         Bsn3Vtp/HgEjnq6gnop5Hje4mTePvXX+H4z93g7rWVNXUAEKrFkRHomTprmMiOhHj55e
         3/wIv1GH3sCWnR+hI0YzROpAlCEjD0zI3gC8hz2KNicYSWc8mKBG7f/BBJ9V8c/O1ehm
         tsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sgvqu0wVnoaMbLm3S8eqNMAkJAM4WCInIMji8pXhAX0=;
        b=l6hdU3+TeZuck5JB5fMJ6tVmoeov/1+jQQZmNN+s8FEv9Nf5gvSgjhK1jE1zqbO79V
         ybm5ggfwwv7x9TVZ000Lk11XIZLZejzMVH2k6Opf5bzpPOgMyz/Ttwg54k1EouSE4GCf
         /frLZS+dSuWQhu6ysnbSs7kHtqBrRYr6FUIBATND6U6zF0HYNFF9b+KLTIYNBLPQVPLu
         VvlHPNw0RGNOtF6IieZ+QGj5ED+XjlrRbXC60qA22qHIv8/SDxdcpcNiX7nB/3XFxraD
         ZfQLqADrOPxxGjZuO4iez80EJWT20BPBxmUXCVW0LSbkAXYOU3tpVvvMjl0r4KyK8bWz
         sfJw==
X-Gm-Message-State: AOAM531a72QyRC6NazHku1l7Ep4mXe9dhTZrkSuDzS88WRI1WyJw0c9U
        TwdY34HIPBVZyj/9zJ+K67DIlO9+z7E=
X-Google-Smtp-Source: ABdhPJyvzKDxAL5f8bvCKjDiCQurAMK/4Tryg0IHDk5Yn9pZsAC4rXhq+qM6+zVMcwhbyYaE0cmBaA==
X-Received: by 2002:a50:cf83:: with SMTP id h3mr20755844edk.63.1633374232394;
        Mon, 04 Oct 2021 12:03:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 05/16] io_uring: optimise INIT_WQ_LIST
Date:   Mon,  4 Oct 2021 20:02:50 +0100
Message-Id: <c464ab5cab6e46a858c6d39c107e92b3b5291f13.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The invariant of io_wq_work_list is that it's empty IFF ->first is NULL,
so no need to initially set ->last. With now having more users of the
list it may play a role, i.e. used in each tw iteration and on every
completion flushing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 87ba6a733630..41bf37674a49 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -38,7 +38,6 @@ struct io_wq_work_list {
 #define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
 #define INIT_WQ_LIST(list)	do {				\
 	(list)->first = NULL;					\
-	(list)->last = NULL;					\
 } while (0)
 
 static inline void wq_list_add_after(struct io_wq_work_node *node,
-- 
2.33.0

