Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4111600DA
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBOWGl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:06:41 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50778 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgBOWGk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:06:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so13541446wmb.0;
        Sat, 15 Feb 2020 14:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=foKquxBAIMXjAR3tdf5BNsaZnzetsrzrXlbRi9LRBb4=;
        b=RJQ7YvF+CbdGHdO2L5RhrHlqH03JTtwPhIA9jRCzKopXjNJF94Cmc5ISajpdCL66T5
         tVPj61kBmx3uFfxX9NTnk67CoutWZiTEQ/44Kq4Ci/hMnewIpCxzBTrjdCNLYHKkItB6
         d5DR5urmh2BclVAvB0xhQmoV0aO+yJ61QR5wOo9ZIFWBQi52ixSF1hqJwriEQbOSTVA7
         HA8oc6CCwSI286/9zI/p3kzkX3PzvBdzZ7CNSAaLNQzBIlPW2M0N87YjXo8+jys4G4Bc
         kwLsrI8RI6Yt1SX8P+qN9N+xbVEWs4Hvytfh8AAlgD/yO/IF2AguLDa/4qR4JifbybV8
         bZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foKquxBAIMXjAR3tdf5BNsaZnzetsrzrXlbRi9LRBb4=;
        b=UlDqrcTI44XHS4i7v9wG1y52yl90fIikrq8wlY2Rr/SG3Oj4fuoEDESSHDoF3TBulM
         9pJAc5jIBrVICiYqwu0WBouH3lHRS72Be0VP7u0T01EGS9p/P/YWMmg+omsrtZkpAYRR
         wQ4PZCgHaoIT8MnmjCYTlMQmSLJ8JjRtFBL1mp3j3dCkByEX4dfD7Oepz0kBar7lYuaj
         gzx3Onm3rFHyba+8AI4fF5IHERT5Al5g9fzf30Cfqh33e9Kbs6A1tkvFedvMGZo8Hd/K
         R9i0QBIW88LHEJsYYKwB8b84Frw98EDON3vdQxptIhdBX+5mCctZgCeFY1/XZYsfSxrp
         AQVw==
X-Gm-Message-State: APjAAAWnJri80cLQMYp7byLlrrOAodHb8/1rK7KKrrffFrVu7KDn5eyP
        is/Ey0RqP8QqrkWNThDqZsg=
X-Google-Smtp-Source: APXvYqy+aZtSryCb2nmDg+j1J5RRUQ49wyVwSv46fP0J2qz81S110OlBHFDxVovPS4Jr4zeMth5jNA==
X-Received: by 2002:a05:600c:2207:: with SMTP id z7mr12496803wml.138.1581804398587;
        Sat, 15 Feb 2020 14:06:38 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id v15sm13281923wrf.7.2020.02.15.14.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:06:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] splice: make do_splice public
Date:   Sun, 16 Feb 2020 01:05:39 +0300
Message-Id: <e7803efcf00c869dcf22b8b9baf7d9b96683c15d.1581802973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581802973.git.asml.silence@gmail.com>
References: <cover.1581802973.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make do_splice(), so other kernel parts can reuse it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c            | 6 +++---
 include/linux/splice.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3009652a41c8..6a6f30432688 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1109,9 +1109,9 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 /*
  * Determine where to splice to/from.
  */
-static long do_splice(struct file *in, loff_t __user *off_in,
-		      struct file *out, loff_t __user *off_out,
-		      size_t len, unsigned int flags)
+long do_splice(struct file *in, loff_t __user *off_in,
+		struct file *out, loff_t __user *off_out,
+		size_t len, unsigned int flags)
 {
 	struct pipe_inode_info *ipipe;
 	struct pipe_inode_info *opipe;
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 74b4911ac16d..ebbbfea48aa0 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -78,6 +78,9 @@ extern ssize_t add_to_pipe(struct pipe_inode_info *,
 			      struct pipe_buffer *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
+extern long do_splice(struct file *in, loff_t __user *off_in,
+		      struct file *out, loff_t __user *off_out,
+		      size_t len, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
-- 
2.24.0

