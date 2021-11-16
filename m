Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F30452A45
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 07:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbhKPGCi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240253AbhKPGBo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:44 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8D1C04A403;
        Mon, 15 Nov 2021 21:43:03 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id h24so14828435pjq.2;
        Mon, 15 Nov 2021 21:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xNMq9GJJA7CIRiH95ibik9uHs9CfsmAe2wbOXiKepoU=;
        b=DzKnaQB+wUFswdwz06sOh6UuNIMNlcZRdYQsNZBecS2AIpjnisA6sds54G2OSNl7OW
         0BXKzD7OAl+lmAWARnW6ZtymVwexFT9BaqU4PAfy9t5rcW8HUA97MKvP3G23I5YkxW/A
         zD2s8N/Psyf/mj0nQNl7HbL6lCk/vQTkna3R5uecrU0AYlxilcZPsUdmisttgRuHzLE/
         qwTdobzPkDJDmJSbxk/lMw568IqQnD2NfCjdWeo0HwLwSo+jbqDCiSXrOpT0pqpV0n39
         z9L1wob7VRPvtHXqJsPegehHTGfEM12hgdYubcl2FgG7qKY5KPV3+UpBH0bGrzsyGuRN
         z77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xNMq9GJJA7CIRiH95ibik9uHs9CfsmAe2wbOXiKepoU=;
        b=N8VNYrur8Jew/JG2Ue5FKfcFFFQDJBMa+tFgt6tgoQPkl4saJBlsul8YcGptm1dhY5
         EQqIFqDNoJXW1pJH8hN1famPMAgWuOKf86Cv8VBcbBpl9p+fE98cx2EIgSjmi4KSgVKo
         OPeqroHl/HbyzbTSayJC8tPZ0NOk49GzldD7FCPDcGNBRHyouABUshaxheTDGUZFQEM1
         /EMaRD95z9QJONmLWE8dJL9z5HIL/tOU3K369q+0NdAGuHzfM/25KJq5ZMtLLIKviPNE
         d7sorCnWmGeQSa0GXHEOSN1UhZoFPDchEuJIVQCuCqmSUdpWazB1VCtD3+KfrMjO3H16
         P9rA==
X-Gm-Message-State: AOAM5334azeaUAkZHP3/ThHEcdWN/eJJJr50lsi2dlo5yWIB7KFHl4sm
        O409M22mtwVuEr8OW9vIMZ/wM6Z4gk0=
X-Google-Smtp-Source: ABdhPJy4/Tbd2aBvDPZSWjue0LOPAsIvPxsbhzWx8MaZWaM8Q0AGneg204Vq85uE5NeNSMe0eAfTCw==
X-Received: by 2002:a17:90a:c091:: with SMTP id o17mr5526836pjs.35.1637041383082;
        Mon, 15 Nov 2021 21:43:03 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id mm22sm1015953pjb.28.2021.11.15.21.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:43:02 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v1 8/8] selftests/bpf: Fix btf_dump test for bpf_iter_link_info
Date:   Tue, 16 Nov 2021 11:12:37 +0530
Message-Id: <20211116054237.100814-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1199; h=from:subject; bh=2OeAqoVgm3UE8yo/6xItJyebkuS6bvyJvQVD3m8v6N4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S7cp9vrG4vOU0yZvr5SpV+sCHwxBvUfioYCwMq 0lXCH8qJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEuwAKCRBM4MiGSL8RyksmD/ 9ykap1OxzGchcNWyb6qBJwWVb2/xIlSSGHWzo99rRvEZvoNlQdwX5ys7GV/8m7U6NLzhx0w1MrQG4O +WvaLbLSff4Gb2Q8DfmQug+XAF26EFhhd6E3VI2h8qR4CJ5uhbqvZp9q+o/lYlb2tUWY32dXcZnvYq bQXA/3FkSofOhUKPq5/CHTic8w69GAs59wugR3GlmQVTDT38STrcptrKCPXQ5OVpWKP8cU8HqGPgn+ fAw0KzQ+sdnzaNMW5eA+eD3WUC3wbKkLO78kcYFaA9/QtHq5Ulb6YtO2t/71Uh7F2qhdLX9o+RhsFz 3h0yPPR+ihC46gpovjzl2tITdUr/TK9ORgGTf0YwRrukGtqiNKk2VUuBABngKOTIZ0aOeV4MLLlfrH bWmpzZ1NKGdwra3g+fzNOKY25D77sQw+Ckhoh9XenHs/2XREDdHeNYgqmDnsGjFW8gmqm0PRG/kRNO A8/MezsfRwxNo8vwDY1XXqdm0nABIntz/w+IRpyvPxYff0jAXUKz+V+6E51EmrRJ+BdaM/FLDd0Op4 saQP5nKttNeElk2g8pjLpPKgczDO7qYB+tPZs0gohBu1PRkPHwLCFDlWFIbWuCuB2ym+jo9Do4Hwe1 WkhAUwcTS0HSDOOXxgMaTS7dnnNy05Yoy373veKRNJNhyTpJF/LjfBEuO5fA==
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
2.33.1

