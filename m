Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4276510D5
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 18:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiLSRAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 12:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiLSRA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 12:00:28 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFD412D37
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 09:00:28 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y4so5026049iof.0
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 09:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFr0GgQXOc+nM0JwGRtBHryCLXLq7d8VyW7Z25ohGnA=;
        b=5JTqIOUedH24sE13pKYmId91QzTHkSMyB+IK2X6hqnnZ5inKC//Pml/g8xJ1PoWJ19
         2fNZ/sC2DFjyihd2OyV6192V9pQZc+zIHk7CRHTaw0a49S4Xm/R9EGmLr1ikkdtbqqpE
         on5RqARk4txBqzDS2U4/aEb8FG0yBaUQs+QiK0jrNJSwZwERL28HzdidwlwBscKo50Xe
         eVL8D2B9fDHrQwuNBRak+viIszYy40ln4niYUrr6QU4UeQ/zQICAeTsg8eK6M+7EhEgi
         6YCSKIDxUjDdfVlspRkpZJhgPDorbMAzi/t17l4HU4F6m1uRcGbAzroTIg88Tbcu4Qwa
         lY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFr0GgQXOc+nM0JwGRtBHryCLXLq7d8VyW7Z25ohGnA=;
        b=cHj2y808g2e3cTKdxn6kqCa+1eWfTBjdaZ7iPWQ3QfpuWmXU5QSlhC4X1JLraI0rBG
         B94dCM5lxlTdF24GNLOMfhKHJPTYvn3iIqWj5afWwSyQLIc49/ltI+KoA2V92pLwzWRY
         Zk+93sc+QZMD/L4mXB1ydn/YAfoXXr2SSte/WapPCB+MRWZKpxVrKDgncNox2JvGNT0r
         DGM7oSx9fmTGN2r0AzAOuKCPPB2tPePDb3X9f3gZQSz5DQxINCI3EmQzp+7WyqMRhlQE
         eo8Jyt7c9y0TMexvZjcUyWhtjrW7WwaMnbtvtKW2AY8For8KVuAZE8IsPyOLGtdUKoiO
         HM+w==
X-Gm-Message-State: ANoB5pkBZOW6soLvLyab0nQRua8DJDlH+B1LSFOIBIcCWNpLIpO0HmEo
        Bx8Zud/73/K5dZ+sCNactdXACQ==
X-Google-Smtp-Source: AA0mqf6PBNZcpV02q9lAWWKFgWxxBvYudSpgjsdrGtd3aCCpeiiavOnG9PUw5JzT0bOx0PhgA2f7vQ==
X-Received: by 2002:a5d:8b06:0:b0:6df:b991:c03e with SMTP id k6-20020a5d8b06000000b006dfb991c03emr4397794ion.1.1671469227394;
        Mon, 19 Dec 2022 09:00:27 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f12-20020a02a10c000000b00363f8e0ab41sm3675830jag.152.2022.12.19.09.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 09:00:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v1 0/8] liburing updates
Message-Id: <167146922615.37948.17402262848405700296.b4-ty@kernel.dk>
Date:   Mon, 19 Dec 2022 10:00:26 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 19 Dec 2022 22:49:52 +0700, Ammar Faizi wrote:
> liburing updates, there are 8 patches in this series:
> 
>   - Patch #1 is to add a missing SPDX-License-Idetifier.
>   - Patch #2 is a Makefile warning fix due to the recent liburing
>     version check feature.
>   - Patch #3 to #6 are a preparation patch to make the clang build
>     stricter.
>   - Patch #7 is to apply extra clang flags to the GitHub bot CI.
>   - Patch #8 is the CHANGELOG file update.
> 
> [...]

Applied, thanks!

[1/8] ffi: Add SPDX-License-Idetifier
      (no commit info)
[2/8] Makefile: Add a '+' char to silence a Makefile warning
      (no commit info)
[3/8] tests: Fix `-Wstrict-prototypes` warnings from Clang
      (no commit info)
[4/8] test/ring-leak: Remove a "break" statement in a "for loop"
      (no commit info)
[5/8] tests: Fix clang `-Wunreachable-code` warning
      (no commit info)
[6/8] tests: Declare internal variables as static
      (no commit info)
[7/8] github: Add more extra flags for clang build
      (no commit info)
[8/8] CHANGELOG: Update the CHANGELOG file
      (no commit info)

Best regards,
-- 
Jens Axboe


