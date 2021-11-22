Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EB14597F2
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhKVW5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhKVW5R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:17 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052EBC061748;
        Mon, 22 Nov 2021 14:54:10 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so820715pjj.0;
        Mon, 22 Nov 2021 14:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6JWpDmyRuBt8dUb8y0nD87bsR/GLwgR+k0+9HPit3uo=;
        b=blrQs8SeF+FxMCKS6164TWAtwcnLLc4huiFoIgd5mP0M/IfYOPmW2dSQD2ELy36CVI
         SP5G3eC3xbDgR8BGgAkOgMMt/gnEWCQZb/qVvECxgaYx4N/7PLNhoLFO4acf/PDggNIo
         7MVkQeHRFV4q6w8iW11xXBkjOp+wJpA3sgV/dCshD+69H+H3d/DABso7A6Q44v4zUc2k
         tcyvpCg0lUwUC/Ak2IGKv5rulAlRS6Czw9P88+nAtOHdWwI8Wcg2QzUgM+/quyoFbrC5
         nRQ9Mvs7sItDCt2yzKe+Z5YAqp+1C9ntaMMOBoqupXxptmLgE3sIkJkHXP7VQ+I3IcgM
         wdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6JWpDmyRuBt8dUb8y0nD87bsR/GLwgR+k0+9HPit3uo=;
        b=XIbuNzB942hC/MlT11SyhTudqKLg8SLf1BJYUk8OnWJJFplqD4gI4PaLxC9gBFDvXG
         4LA9nbG9UOhUHjBoTGeI/VfmZSg1tk49v5oHwjif40Wt52mZ0ar+eQSCi+0s/pYd3uUy
         mISU3kcJ7ecV6Sm3vRxlrI2WMlv6+UDBNupI8baduCcGOalIaWSk88yfCa8IrGd2Ke7s
         rKTqBWg0QkS/fdB5Ui84VMVFVxQ7d77lLj+mrZYfsQw40RMidBZJcNi168K8M5iCYlzb
         j2NmChgoTr3tvNtqrih60/SrcKs2sRq8dxJTQVQm2WrC/1+wdwNM/7VzaJ+gLXrVVnnC
         F6SA==
X-Gm-Message-State: AOAM533t+gkYvMH/PRoOuhlBs8vU2LtTAjTNop/HCufV55dQPWuYe2vM
        vP0k0JhcZK93qeNT5gLCt7rQFckxrkw=
X-Google-Smtp-Source: ABdhPJz3Fnee9gSo0lRhNT3FqaquLA6YBqY26z67T9sYknAdZVIlqKKAdNHDNA4dHeYqiyWnF4jPtQ==
X-Received: by 2002:a17:90a:1b67:: with SMTP id q94mr511543pjq.119.1637621649392;
        Mon, 22 Nov 2021 14:54:09 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id c15sm8511308pjg.53.2021.11.22.14.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:54:09 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v2 05/10] bpftool: Output io_uring iterator info
Date:   Tue, 23 Nov 2021 04:23:47 +0530
Message-Id: <20211122225352.618453-6-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211122225352.618453-1-memxor@gmail.com>
References: <20211122225352.618453-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2337; h=from:subject; bh=fchbbGqOBTHhHf6cxv4eARket982nyTwqX0o7rShbKg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrLRFkkqFnipUhBfvYLaoNQmk2cfVhJa+lOXyZy BjqxVfCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwaywAKCRBM4MiGSL8RysyLD/ 4+9AEkVCAdbZ/ZK5wmDynX/JfWoot1Juv6q1lxXcb9lRY9RN992uXa55Pfsm67XlCaY3X7j9yu9xYB OhbuvByhrlC6frkHkAKuRDIldr4GA0YgZlseAAB/m3RRCvuNFYpdfsVQ8RIOd0Xg1mbtWN9RbsWZtE cb3P89+RKVp2pwkQzESaLzRRSRqP7U/vTHu82ntAeZdiqOmBJtyUbubL2RvYH4grxa3P3ymJ7z5xol 3QABcxe4sBmeixcHGBIckLOYFQtsgSBD9sMH8jk1xHvqftINxBpq0zy9NmHxrDmzlLOSyYgfU7Vdsg uyIEJw+9zM9BWJLXURTS+8y8AIJ3/yl3FpeaMQcGMzF1Mnt5EynrfGTbG348BDnSWXLNPc0miCvkY/ WUwIfzgI42S/LiTwKFq4B4RvUbN76GScAuPK+9GQ2U+eGYA8uGEI6c82eONgIciuRJo3jTxZJUqvAS IDQapUDMztQpZTKDxgtyUp0N0g3qm1twh/JGlrscDL7vllas/dzN8QjP8sLpF6lz7exRr/yVyoVBfb dKYuFPcFrBcB76kLhPwKiRf9Q0PQrORgG94xPWTc4B3fU5gQZJfhhU6IVEhqowFqM56MeVuqgB3ymX xoW2O88LyWVqvXCyE9uCx98Uxh+ccjnx/C8cBFCsdNxm2FPyPoIzcD8nKEwA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Output the sole field related to io_uring iterator (inode of attached
io_uring) so that it can be useful in informational and also debugging
cases (trying to find actual io_uring fd attached to the iterator).

Output:
89: iter  prog 262  target_name io_uring_file  io_uring_inode 16764
	pids test_progs(384)

[
  {
    "id": 123,
    "type": "iter",
    "prog_id": 463,
    "target_name": "io_uring_buf",
    "io_uring_inode": 16871,
    "pids": [
      {
        "pid": 443,
        "comm": "test_progs"
      }
    ]
  }
]

[
  {
    "id": 126,
    "type": "iter",
    "prog_id": 483,
    "target_name": "io_uring_file",
    "io_uring_inode": 16887,
    "pids": [
      {
        "pid": 448,
        "comm": "test_progs"
      }
    ]
  }
]

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/bpf/bpftool/link.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 2c258db0d352..409ae861b839 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -86,6 +86,12 @@ static bool is_iter_map_target(const char *target_name)
 	       strcmp(target_name, "bpf_sk_storage_map") == 0;
 }
 
+static bool is_iter_io_uring_target(const char *target_name)
+{
+	return strcmp(target_name, "io_uring_file") == 0 ||
+	       strcmp(target_name, "io_uring_buf") == 0;
+}
+
 static void show_iter_json(struct bpf_link_info *info, json_writer_t *wtr)
 {
 	const char *target_name = u64_to_ptr(info->iter.target_name);
@@ -94,6 +100,8 @@ static void show_iter_json(struct bpf_link_info *info, json_writer_t *wtr)
 
 	if (is_iter_map_target(target_name))
 		jsonw_uint_field(wtr, "map_id", info->iter.map.map_id);
+	else if (is_iter_io_uring_target(target_name))
+		jsonw_uint_field(wtr, "io_uring_inode", info->iter.io_uring.inode);
 }
 
 static int get_prog_info(int prog_id, struct bpf_prog_info *info)
@@ -204,6 +212,8 @@ static void show_iter_plain(struct bpf_link_info *info)
 
 	if (is_iter_map_target(target_name))
 		printf("map_id %u  ", info->iter.map.map_id);
+	else if (is_iter_io_uring_target(target_name))
+		printf("io_uring_inode %llu  ", info->iter.io_uring.inode);
 }
 
 static int show_link_close_plain(int fd, struct bpf_link_info *info)
-- 
2.34.0

