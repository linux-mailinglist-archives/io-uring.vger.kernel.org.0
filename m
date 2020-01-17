Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6614143F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgAQWmW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:42:22 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42165 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgAQWmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:42:22 -0500
Received: by mail-lj1-f195.google.com with SMTP id y4so28040916ljj.9;
        Fri, 17 Jan 2020 14:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=f7KjJQSyN0DZBmAfSq0BADXIOQDfiNXEXxqfU5tVlv4=;
        b=boiDgSI5WA2hkMZ48DUJcoau+/KHyaPH1LTwCn7OvyEigQwce7K+I2pP4/vNUhw7LL
         ZXqYH31sQ78I5mOjxgYpDd6CkIy9tRX1OFe1UJWT4fQcGuFwoiowpQybpkqArkC4LjO7
         KB8JQILeSjPnf7K5KdFkfG2uQ/YiEgXvXoOWvUQ/bDtIg8teToVGFOK6yNbME5fGOA5z
         4q9l/wTUfX80SeBmlDWhar4s0KxKhZyT2+XnkCQvrbWoYjSdRqFPVZbBRNkbuo2oGMly
         H1zPZlf3ptRv3E9vR06mc2EN+DkNlgtc/Dz42IEFVxRB6Zk/7kkuJp4cHRjioUMPKHpJ
         IcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f7KjJQSyN0DZBmAfSq0BADXIOQDfiNXEXxqfU5tVlv4=;
        b=IrDj1obikAeErwO9ZHSxCn1KfWvGxzdyGdYqKtxvPjtVIOA4XHdrIdBqp0a59pgGWP
         8FNh1h4inDJ+IZXc+gAazKlD8UcH6T9zWuu7eyoXOtxIh7ZLo/CE1Lc6jjA2Ey3qpRHS
         ojKZb6owFYFCeSb+ltGLO052cc9Gi8FW3wudWQFZ8vganaw2UMPljXgfdTaNBs6bLPGH
         7O6jU95r035tM7CKXg+XzcU+oAfSMUA4Nkam+bKLgF42pabFjnUiS2fg8X+1YwfBxmkp
         mdKoLGlukBnq4387N+k5wsVtKZXSDotj6/xkkcYmilTCagV7njj7Vg5DFLsLLmTSgy/X
         Wo9g==
X-Gm-Message-State: APjAAAVJyiHuolhWpmro96YliurAhxHNSfK/09JYgKgE9CuRwLBZACVo
        LLAzV5GInKXGWVqAD5Pred3oK8KZ
X-Google-Smtp-Source: APXvYqzdkmHgPectk8gohPr58ZlsnsD6/JUTsHeID2uxBxzTSEc2TrW03/wcPkzfgCSWB7Sh7GV5xg==
X-Received: by 2002:a05:651c:1a8:: with SMTP id c8mr6892295ljn.207.1579300940395;
        Fri, 17 Jan 2020 14:42:20 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id h14sm12657648lfc.2.2020.01.17.14.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 14:42:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] optimise sqe-to-req flags
Date:   Sat, 18 Jan 2020 01:41:37 +0300
Message-Id: <cover.1579300317.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
References: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

*lost the cover-letter, but here we go*

The main idea is to optimise code like the following by directly
copying sqe flags:

if (sqe_flags & IOSQE_IO_HARDLINK)
	req->flags |= REQ_F_HARDLINK;

The first patch is a minor cleanup, and the second one do the
trick. No functional changes.

The other thing to consider is whether to use such flags as 
REQ_F_LINK = IOSQE_IO_LINK, or directly use IOSQE_IO_LINK instead.

Pavel Begunkov (2):
  io_uring: remove REQ_F_IO_DRAINED
  io_uring: optimise sqe-to-req flags translation

 fs/io_uring.c | 65 ++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 34 deletions(-)

-- 
2.24.0

