Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8109226918C
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgINQbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 12:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgINQ0H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 12:26:07 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA75C061788
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:06 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id a8so166850ilk.1
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RFnfZytjklQ+7pYys60IfyrHOHTrYbp9e4RL+6PGCH4=;
        b=Gg6EIZdBLOL/uaIGKl7tzehKzT5MknOK9GS94ViLY5cfORngsyCcJUIUvgtYrx57xS
         +vIMeytvZyqE6FDZXueSefO3C3ZB0suCi/DiGQV7l8MnnIZ2YbhnEzYMOxLJP5nntxJC
         X2Ad6ragY++Wq2JuDJ+TgXmEYiNufb3h0iMEoxYX4P+xwluSJCITt5tprOF8vpz01gMP
         9DhAm1xlYXF998SxqqfGpHCo0AKA5FmWTH2p8H0a46GZh8wx7iEKDYZPxc4BfXySfCPh
         Luyh4+8i15RlDNLm6KqaqoD5kL/2JMAH5rvzCEsWK+fOF4RZ+rrWoc99Epx13WfzUd29
         LV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RFnfZytjklQ+7pYys60IfyrHOHTrYbp9e4RL+6PGCH4=;
        b=igaTS1nWPeUvP/mrYdXgXlsifcX5HBYhd96bc1wyzbQjyjdEYNILdU52bErHNA8Dw8
         8IowO1GogmTnrOij/VM9gNCgime5avxRYbPnRYLx+I8IU5QNzzBBERmanr3HnY1rMpWw
         G1pt0yZCD+sLPxHtztzHFFOH3RH6+xk40ucFa+33G1EqtLpa+/YNkZbbIfSrJUNqgDfv
         4BJ5lw5ao25DZWJdFFTHYrp0tjTNrYbGVbGpKpQWZYjgS4XRwBSOVoY/Vx4ji1hhmLW3
         RRpgIIHFNrOj3Y0yxWV5Br7Ad9yiaV7SeWsXwMWGvWehN6P7+vNDav1cSHb8m62Qq9ut
         SmVQ==
X-Gm-Message-State: AOAM5322Xrqi1VS8/j0tRisEqNqJTspMK5/dNVET1LscYFe9kDXbILuV
        2970BvI3wVuR+LBESIFfj7CYJ2a6wge0NvOV
X-Google-Smtp-Source: ABdhPJzzVaDPC33B0FvgIpwE3PPGcUDRmwbLrGzu02v5rvqxXO74/MYuZwXgk60ZXe0gWRUhcTP9Kg==
X-Received: by 2002:a92:105:: with SMTP id 5mr12070351ilb.36.1600100764805;
        Mon, 14 Sep 2020 09:26:04 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm7032261ilq.29.2020.09.14.09.26.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:26:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/5] io_uring fixes for 5.9
Date:   Mon, 14 Sep 2020 10:25:50 -0600
Message-Id: <20200914162555.1502094-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Various fixes that were found through testing and inspection. Some by
myself, others reported.

-- 
Jens Axboe


