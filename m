Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6C21E114
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGMUBS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgGMUBS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:01:18 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A91C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:17 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a1so9376277edt.10
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s69G7gOHKVvrJVmJFbYm1tgKs5TSbZCmeLLSKh60v4o=;
        b=MirvbxGsbYasQVshEQLUSzurhUYRAeIdy5luWrwajeKxpHNnU7f8Fx9/oQ9YuenLM0
         DcyinBRdMBXcNY+T1P1rOMzGvMY0El6kxKV9f6sO990zljrGMxjAHt+mxcNvXxv+SQmd
         qMn+DRll8PZzztoB82T09WhyTGi1THRzZUp3h/2hTsxrRbXrqLK8wSkriKBo1UHEsOKQ
         lUejL0uHlwZ4rihgCX9W6sKxpjqmTGEY6juWZ/ybCy5UNoWSB/dng4rH6KBKRah5F/Tf
         5VEahf+39BZwj9IZMZLR8Jcku/FMXHXEkylR+uVXsMDy1EEsO/6dUkWzG9lC1SiLJbPw
         TAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s69G7gOHKVvrJVmJFbYm1tgKs5TSbZCmeLLSKh60v4o=;
        b=HeW2zdOlmVBKLlx7KLEG8R5SPJQGP9ZnwWG40b0B8i/EjN7jMZp8eLtLQQx5bYOjz8
         YLC1o7M6jOIq4CrPuY8hOhZTj093H8a1hTGpXKgosHpLQNFKEckI6shvKiKPSQ7TG5IX
         82CepkFykRf1FnQOvugs49Vvm7seR8VYq3/sgdApckVICgASkW8mVI+8iMQOB9pvl7Lv
         N9FGwi5sSfGkElloaSrfk6cfOE+upRtQcZltUleiOSlyuV7Bbt7yMGInnZKql5w6Oi2J
         W4EGs1uC6wJwWrzH/bLTAtCoW2u5UjJ+6vJkDzM0jXbXpVtzrZAD5bP4vFyWGdTVMyHF
         mp+g==
X-Gm-Message-State: AOAM5324Af79ZmBXPIE+HNj89I0Fx3lGx6QiC7YUAYfuDQj2kpwVsZ9l
        84xlENUoBPDCqXmI6mn9wU2FcHPX
X-Google-Smtp-Source: ABdhPJyqV/dwv1avPUB+Phb15TOaxVDIR7z3r7h9odjnY8g4qWaNW/EI3kOdxdPcwUVCpV6Pqz+F8A==
X-Received: by 2002:aa7:db57:: with SMTP id n23mr986255edt.235.1594670476677;
        Mon, 13 Jul 2020 13:01:16 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm10520408ejp.51.2020.07.13.13.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:01:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.9 0/3] rw iovec copy cleanup
Date:   Mon, 13 Jul 2020 22:59:17 +0300
Message-Id: <cover.1594669730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Small cleanups related to preparing ->iter and ->iovec
of ->io to async. The last patch is needed for the "completion data"
series.

Pavel Begunkov (3):
  io_uring: simplify io_req_map_rw()
  io_uring: add a helper for async rw iovec prep
  io_uring: follow **iovec idiom in io_import_iovec

 fs/io_uring.c | 78 ++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

-- 
2.24.0

