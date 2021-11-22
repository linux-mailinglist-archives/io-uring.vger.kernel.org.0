Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1074597FF
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhKVW5g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhKVW5a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:30 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C23C061574;
        Mon, 22 Nov 2021 14:54:22 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t4so9233136pgn.9;
        Mon, 22 Nov 2021 14:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SOu70OAblbF9iCNJCmnZM4cFR7dOkECnjCLjb7r/oYs=;
        b=NDc5jZxJOtHIWkOdNQa7BT3oLbcywOpK81t2SqZcUMAEPs17e/Bfdw+qbs9qWMgNQF
         3Mb1Aa9kle8VNmHamovYxnrm5sn8xElnBnxfXmbNpmomikJ8+hiybNXooEnjjYoIk9zf
         sHnimREdWt6rj0Ckxqyio2FzalvlTSivFP98VtbQigrdhzw1zYcLtZ0Tp+lgto+yurOu
         9P1sKCRg9lXGN3RDibBoBEYNhmZPVySajRgZ/PjEZ3Rabyt3DBD+Ddz5BhmAP7k2FwuD
         J0blABBk7sl372HvnMiKuPNP5SeCO9lf07yPmwAF3utw9lCb81iJ/W/fWbHz4KiQQKJZ
         UqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SOu70OAblbF9iCNJCmnZM4cFR7dOkECnjCLjb7r/oYs=;
        b=cxFLiSYb09WJF4yUoJZqggv2rO7Csv9SFn/LZFhJgn2eBmXVPSiF7WVt3JHTLdkV6G
         ilyZMC9koF23qlcfSR1x2W9q9b37r3Odj1n4mLL/C+6Pxacg8mSFbbVCZLvl+5hxtSXK
         R0AjudZ+MuANXm75wPdLNSnP3pAUlM3tHyVLNaK0hLl7sOtoh1qJ6bVO+PfzJdGOgrUz
         dOsqMcXePAlXtnXm5oEbqUD/Zq2fW7BjeSkWcHrfZlqDBAoiU7oT1T1pPe17R6a1+uN7
         EjgtyBUIv3kO5BQtTGpYsHw/ZvDHZxno2LoHvc9nHo+l/alRqPCtI9F9NcLZOJTPerap
         4oAg==
X-Gm-Message-State: AOAM532KTJqEAcQBfKcEqhzx9csxQ17Khiztb14I+AMt6rgdLpJyKTbY
        3E5MHj7YMefd0nYuMkw0qOihgg02ExM=
X-Google-Smtp-Source: ABdhPJyndHNdKz8o3qLqWALzZa+zE7vHJHGMCH0H5aYOiYze6rtviJajL8IAOC/3JfHQObHq5EK5wA==
X-Received: by 2002:a05:6a00:1946:b0:492:64f1:61b5 with SMTP id s6-20020a056a00194600b0049264f161b5mr522057pfk.52.1637621661690;
        Mon, 22 Nov 2021 14:54:21 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id ne22sm8599329pjb.18.2021.11.22.14.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:54:21 -0800 (PST)
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
Subject: [PATCH bpf-next v2 09/10] selftests/bpf: Fix btf_dump test for bpf_iter_link_info
Date:   Tue, 23 Nov 2021 04:23:51 +0530
Message-Id: <20211122225352.618453-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211122225352.618453-1-memxor@gmail.com>
References: <20211122225352.618453-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1199; h=from:subject; bh=Aa07OX8z1krQq2qMJczuwnNeBDERtUcS4LltNhLXoso=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrMZYNOTuXBlrXif/E4BaVe6f0+nbks5dpSVkN7 Gh/yukqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwazAAKCRBM4MiGSL8Ryj+hD/ 0cFj993tNTv/rrc43Ltfw2RYVEMcm/IWYPE0yhY09zXC8dRKYXXt5mw5oIFADL9Po2rgpkKOPpGSVH XT+gUMv/8GsKeE4HEveGq4/9yHymC7yVxvLr9ACY/FGbTek5hhwBmcWk5sgE2oefbesDao5uQ39rpY m809CbqDlHueqXk0vvP/454LdJE5igkMqdKAqF+k154kEc48EejO4aUotkY7iJrLYwDWiqI2tNj86f YzggJyAKUl5Jf673MW6NXmFmHA5MD6sbDlRVwE1fe3QWjfPmExOrF13o7G4vFhKwLKnPVle9IU0Xj0 Z5l3/IPAmIHfTCBrStwonCrQ5HjXkL8zh+rbsNHxYfiP0zhxydN9TUOjR7gPKOMcapYmZk987sc5w2 tX7IwcsxTE3DI/8L62b56j+Rxyen8sJWP9YO8YDWJ2zaoX2fCpFDY818NEmjjTKCDY1Cqn4iFQ1F5c PQKAxB7ls6cksekbA64wn5ws031KS8dsZ0wJ6tXzD8pROTvetLOKnqwL2hOEd5qX9b3muCJk4bnLPs 8VBV2bu7m5n2dNntHi1FVOTi6N1cqbteWIop3tmh21kWzgTbHcxJGMqo7fUsiKIfk+f22O68cLM5FR Hd+j9U8WNgXQGnrg7bNXBDFdfvldGDqaswdjhhrpQz0eSK9JnMGMWTSIfHBQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we changed the definition while adding io_uring and epoll iterator
support, adjust the selftest to check against the updated definition.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index d6272013a5a3..a2fc006e074a 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -736,7 +736,9 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 
 	/* union with nested struct */
 	TEST_BTF_DUMP_DATA(btf, d, "union", str, union bpf_iter_link_info, BTF_F_COMPACT,
-			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},}",
+			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},"
+			   ".io_uring = (struct){.io_uring_fd = (__u32)1,},"
+			   ".epoll = (struct){.epoll_fd = (__u32)1,},}",
 			   { .map = { .map_fd = 1 }});
 
 	/* struct skb with nested structs/unions; because type output is so
-- 
2.34.0

