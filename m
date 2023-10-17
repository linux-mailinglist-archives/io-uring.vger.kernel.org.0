Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41957CC33F
	for <lists+io-uring@lfdr.de>; Tue, 17 Oct 2023 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjJQMe5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Oct 2023 08:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbjJQMe4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Oct 2023 08:34:56 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5E4101;
        Tue, 17 Oct 2023 05:34:52 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-99357737980so926820066b.2;
        Tue, 17 Oct 2023 05:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697546089; x=1698150889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/XqDc9sG/4KnSxtdeA1TCIkGdrj0dQn8EvOZY/N0NE=;
        b=tDVLsyUofWLxdmC5N3KM3Z6sxO9IU39AlYDSGFTiofWLljmGKtZReGywRoAPttVYUK
         6SRblw7zxeTDbKWn0OnpbKYWEaKa74gugTlXL8YQgYCaQrCH2Mat6L0KoOrIdcsEcVL2
         RXOVxfovNzrDFPQT031zQZqXdUJdHCFALZHdMCGKcQ4hT1fYyd/agN8PPsQpfktqeHca
         sGdfQSqURVSZbvXh0AFfc3eicrNZRr7pjtxErUEZ6PovKbIwjFYq2wWhe70YACMqnIUu
         CF8fRbFKz5SD3AqSBXU3CfjCuM8lP4I/HcYKDVCl4dfZrhtBswchZu7tzQYr+dchM8N4
         kqRw==
X-Gm-Message-State: AOJu0YxhZF5lN90Ml82rfefm4FdqUqcJ2/eQIqdWawRnkT2eDDJpSY2o
        izN6JXsftt1f5yu3i+8baC0=
X-Google-Smtp-Source: AGHT+IHAumeXbSxFFz9KsI+FT2kivwPXTkExyh5Y2KSA5CDXQBaYmK2h/R/lnaD9sCEe/4CInrj5qA==
X-Received: by 2002:a17:907:3182:b0:9b9:fce8:e073 with SMTP id xe2-20020a170907318200b009b9fce8e073mr1526408ejb.26.1697546089188;
        Tue, 17 Oct 2023 05:34:49 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-119.fbsv.net. [2a03:2880:31ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id 29-20020a170906001d00b0099bd5d28dc4sm1181919eja.195.2023.10.17.05.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 05:34:48 -0700 (PDT)
Date:   Tue, 17 Oct 2023 05:34:46 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>, martin.lau@linux.dev,
        sdf@google.com
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v7 06/11] tools headers: Grab copy of io_uring.h
Message-ID: <ZS5/Zk60X0+ZX+hf@gmail.com>
References: <20231016134750.1381153-1-leitao@debian.org>
 <20231016134750.1381153-7-leitao@debian.org>
 <652d877c.250a0220.b0af2.3a66SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <652d877c.250a0220.b0af2.3a66SMTPIN_ADDED_BROKEN@mx.google.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Gabriel,

On Mon, Oct 16, 2023 at 02:56:55PM -0400, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
> > This file will be used by mini_uring.h and allow tests to run without
> > the need of installing liburing to run the tests.
> >
> > This is needed to run io_uring tests in BPF, such as
> > (tools/testing/selftests/bpf/prog_tests/sockopt.c).
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Can't mini_uring rely on the kernel header like
> selftests/net/io_uring_zerocopy_tx.c does?

Before this patch, io_uring_zerocopy_tx was not relying on "make
headers" headers, as far as I know. I think it was not a problem because
there was no CI running the test, and whoever was running the test was
relying on local io_uring headers.

My patch is, in fact,  adding the following flag, which relies on the
headers now on:

	+$(OUTPUT)/io_uring_zerocopy_tx: CFLAGS += -I../../../include/

> I ask because this will be the third copy of these
> definitions that we're gonna need to keep in sync (kernel, liburing and
> here). Given this is only used for selftests, we better avoid the
> duplication.

Right, I don't know why this was the suggested way, but, that is how
people are using it.

I can definitely get rid of the copy and do the same mechanism as
io_uring_zerocopy_tx. This is what I've tested, and it worked fine.

---

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 4225f975fce3..9f79a392acc1 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -383,6 +383,8 @@ BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) \
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
               -Wno-compare-distinct-pointer-types

+HEADER_CFLAGS = -I$(abspath $(OUTPUT)/../../../../usr/include)
+
 $(OUTPUT)/test_l4lb_noinline.o: BPF_CFLAGS += -fno-inline
 $(OUTPUT)/test_xdp_noinline.o: BPF_CFLAGS += -fno-inline

@@ -551,7 +553,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:                   \
                      $(TRUNNER_BPF_SKELS_LINKED)                       \
                      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
        $$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
-       $(Q)cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
+       $(Q)cd $$(@D) && $$(CC) -I. $$(CFLAGS) $$(HEADER_CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)

