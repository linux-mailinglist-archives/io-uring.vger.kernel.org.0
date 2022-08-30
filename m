Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8C75A6F89
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiH3Vth (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiH3Vte (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:49:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538628E9AA
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n16-20020a258d10000000b0068df1e297c0so719110ybl.15
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc;
        bh=nkzMCqKgjBTn+NwznXGF4FkMKBv5sNXeON2LIxVXB6M=;
        b=kJlmMVVbY7IXNl91XGcBvO3YBT3quRQF4WCS0SiH4LOLG/e+9p2jaPHVw9E6t43+lu
         d4/47XlZrYUEtJ7XQ4VgzKUrbfj5xy9BOKDP//VyLPwp6hXR8zYzPt3dQTar5Wyr4GYS
         iZIbWUJ75o4n7+UgTsXC+An80tm2UyPOQgFq5wJiP9bNIbl98o3r9SGFN0OGKpWzVCwL
         D90b1H3jXLeXTLKjKOyg3XK2WfiVlhvPG/TS9Z+MZLclTKFSEr9IlFYU0A0pKe+sQn6L
         rk2/ZWVdc/gD2rOE75MuQ1Xdte4UkYIWIQjcJTwqiH4rcTqyxgiTvaJazxYK/g79dGii
         T0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc;
        bh=nkzMCqKgjBTn+NwznXGF4FkMKBv5sNXeON2LIxVXB6M=;
        b=0tafe3Wv59y2AOiAxCPV9gMP54P7SJx8LDvBgqb/M56of726MS/TcXUZCTMdXtNVBt
         kho49cTegdKVZRUagHD9+SZdTvm7mEE/tG/YBsfkPa9poMGYnLomWFbQhKPL+Y0vYR3G
         kZMOmBWwhCEIXp7sIlLmxzzfALQYodfWDEG9Gd09aQm7uijoOV0rHXi58TLOE/uOHDAg
         R41MJXKRRpmxtt74XNV0HS3alNrhLQ0F11Yo3gfKlOiDKZVaRe6/gB4NpABVN5cXPv51
         C3QN6V60fGTw8e8fY35zDeS4SUfccL+Wesasvkfyq7xjj0++FXyzOtDQxeE1CuHb6c70
         w9kg==
X-Gm-Message-State: ACgBeo3bivP6FzxXKyZRT6wj3fFvqnuIR+m8f0hYlNJC2usvHFiBMnkE
        OEfIZ8wIldK57MHlS/8ldqD9YD6WQnM=
X-Google-Smtp-Source: AA6agR58VLI71n7hWTuP/n58j09zS0GpQ603/kDNR321OvTW6NJyNZKRSs+4OQb0POQ9FkLHMKokHnLGLkM=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:e90e:0:b0:695:64cf:5d2 with SMTP id
 n14-20020a25e90e000000b0069564cf05d2mr12975575ybd.541.1661896169455; Tue, 30
 Aug 2022 14:49:29 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:48:51 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-3-surenb@google.com>
Subject: [RFC PATCH 02/30] lib/string_helpers: Drop space in string_get_size's output
From:   Suren Baghdasaryan <surenb@google.com>
To:     akpm@linux-foundation.org
Cc:     kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        surenb@google.com, kernel-team@android.com, linux-mm@kvack.org,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "=?UTF-8?q?Noralf=20Tr=C3=B8nnes?=" <noralf@tronnes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kent Overstreet <kent.overstreet@linux.dev>

Previously, string_get_size() outputted a space between the number and
the units, i.e.
  9.88 MiB

This changes it to
  9.88MiB

which allows it to be parsed correctly by the 'sort -h' command.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Noralf Tr=C3=B8nnes" <noralf@tronnes.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 lib/string_helpers.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 5ed3beb066e6..3032d1b04ca3 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -126,8 +126,7 @@ void string_get_size(u64 size, u64 blk_size, const enum=
 string_size_units units,
 	else
 		unit =3D units_str[units][i];
=20
-	snprintf(buf, len, "%u%s %s", (u32)size,
-		 tmp, unit);
+	snprintf(buf, len, "%u%s%s", (u32)size, tmp, unit);
 }
 EXPORT_SYMBOL(string_get_size);
=20
--=20
2.37.2.672.g94769d06f0-goog

