Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D61F4645E6
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 05:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346569AbhLAE1p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 23:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346513AbhLAE1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 23:27:36 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96C5C061757;
        Tue, 30 Nov 2021 20:23:52 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id r130so23054259pfc.1;
        Tue, 30 Nov 2021 20:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FHgCXMZqFYvkD6qdznJ6BR7nNTjcADokUMa/fFZF/nk=;
        b=N4eUQuHve5bweBa+tX73OvM7XorYiCyjlF4pFKjJ4Nu8Qh7IOBSQ6Gl6SaXVElnK1s
         18Q82hLsGIYIgo5KTsrFxY13Slh3iSIV2g8DMirh6AzPUITHRevAbRDczaKuEULjF/Ju
         jzsnmQaqbsn1FQ5DlHEFVEsTTj/6E4Gi+VJzN3ibzB2eGM1Kyn+/kwdnHRcE8mv1ayPB
         VcJzxvHfXCgHCVD2fizFhUb4bkEm3wbQX2W+ZZ/c//QareiCRvBTwGmjL2Q6cSVC8re+
         s4197kdgoTJYK/g6JX17kcjWTLdsjJ/UXOJu96GNzKoVGVNJfqeojfjDXnA4e7j9kDyM
         mQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FHgCXMZqFYvkD6qdznJ6BR7nNTjcADokUMa/fFZF/nk=;
        b=3A/tSP5lVoFut+KJv8b+aE9I1qPDH5SfMoEkRqRSTRyLUGFEkf7sbiDC1WQD6kjwzx
         05u4m/aWz4rSNSAVKi8oElPUyj6t81VbtCb3XEx0FGy4kXfL7ABRxvaiwho9Aagz/uPu
         L9j84KwBOAxwBf6LqTzwBLrX7XZeVtjCctXrUtr1I7censiaGQHIlfrmuUy11BUe4ixr
         n6AEZy0Y0+Z4IBPBU9rvUUZflOPUNQwPy1Ivy7Agsp9esG/L8PGxSyuk2/ew9pofWpe/
         /4T9Hs3JZT24VYgVRrYWutWwB3+fJkM4UK3SrtzXPSiza3W3QG2Z9jceBd/4bR9sVeS9
         sluQ==
X-Gm-Message-State: AOAM530Drwf3IEh2BtgLa1K8o20yhLohHurfi/BbPPyv60HcWlWadDMM
        xYfFvoIXa/VbOPQwI0bbZgIQ6zW0PWo=
X-Google-Smtp-Source: ABdhPJyGdJTP/hIderRqDZG9P+XcHQipQ3pQqC8+czstFQ5AbMAZpqLzDJ4MWFfh4ZCxNxXS4HJTrw==
X-Received: by 2002:a05:6a00:807:b0:49f:d6ab:590c with SMTP id m7-20020a056a00080700b0049fd6ab590cmr3666943pfk.32.1638332632300;
        Tue, 30 Nov 2021 20:23:52 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id v1sm21695285pfg.169.2021.11.30.20.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:23:52 -0800 (PST)
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
Subject: [PATCH bpf-next v3 05/10] bpftool: Output io_uring iterator info
Date:   Wed,  1 Dec 2021 09:53:28 +0530
Message-Id: <20211201042333.2035153-6-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211201042333.2035153-1-memxor@gmail.com>
References: <20211201042333.2035153-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2337; h=from:subject; bh=AzWo3KQKcucubukC3jB1Ua1DZJ24Akt6XiNikymWxlw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhpvYyf9f2STSREJ6G62ED68G1TqCyrjJoGgtD4FQh b+FkM2eJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYab2MgAKCRBM4MiGSL8RylWxD/ 4oDbn6W5hPzuxfCu2kQx0N50BQLbixvZ3qThi1mL/zQks+MRERR93GlZuDhIeNphmafsJl7frKuf9R YqpJbt0Msvmkz9pZKbZxLIK0F6RyXfByPkwovjMxvZnkK0hXGFBtr22M8ikpvJ9k7Au8oLtfPhTCIZ BY3QIKFndECrluPHiJ4jshF5qR+11L4lYKyBtFn1KOvwQZ6znF9/eoQwVuSguoAB2NNFLFaB8d7+to /tJ/BTBNcrikz5n/GWkkzwJibBEEX2M9Xrne9iwBGLKYx/dRLXUvsOx4XzIqSsKhfoJvyX3Xtc7Gbk vH4Hkj3hyCarM0aXoFMTP52Npoeoe0KkbmbGW+44oEwrk7/tQ/Phjw3mg7oIsm15uZ182iSaxKzQKp cEdaKe3j52pQGO8Y8j+Cl0knyinszSiV3bIQrpGrF2Pyq9/yt45udgCXTZitHWe3FF8K3q96Ake/ia 1jLK5ZwK/YZszQqAW4B4d4MfCsidvR5KGRu42VSPqtEGPZk/1LNA+9yyX6ayGOcR0twrRhW95Hj4rv mo3eg/I0uPM1ipaVNTtyarOnwWNIFCONAs0xijq1s4FOOp49byoQ6NLpN9aqrHcs1JOXXLAr22h+u2 gJuWCOLyWhlHAQoyQd5JZJ9Kdxr1eX0SrQdyoT1TM5QU/2Ynz5U+vta1a1rA==
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
2.34.1

