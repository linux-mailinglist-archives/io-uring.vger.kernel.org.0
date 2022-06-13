Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DF9549183
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbiFMPYx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 11:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387221AbiFMPY1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 11:24:27 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5672113746A
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 05:50:06 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id h18so4211430qvj.11
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 05:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=0C1gSe6v7Ey+4Ln33U0g7oeVNYl0T38ebRXggUUmBYM=;
        b=3gBjTTkRp7uyXcgDcMARa5ErRKuvVtjJGc/hhJbzWGQLjWuLmluZIQDRHD7uX6JOhp
         3w0IkJ2G24Y43ClvOWoH4kYwcn5SvtwMYCsX0t5BsXMWSK0UH3CWiAnN4LOfiDHneVYf
         99qCyuozxo9xlkmy0ZwZWc5aPKXe+ZFSJNdD3KmohfIvsaUpfTD8thdQ8W92hfZv67jf
         VAoq66r9Ob+OmgtbrSoZt+q3EeM5elrc5z57gymo739WD9FUwBTiN2FXAKZx0xtimDM5
         T5r4cyWEozY1gkR7z2bCiX01ryMf8CsfFu6N+EwpQohz5ZYeM487W4yDQmXCx7q2AyXl
         C4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=0C1gSe6v7Ey+4Ln33U0g7oeVNYl0T38ebRXggUUmBYM=;
        b=5o3PugeX65XqZ0dssI3/qGzqnz+EZIr2pqeGhGmt8Sg8ZH+GbWxOIDWASDvl4cAHQz
         HQOJQodC6zcvIt78+BeDbztpiNSZ4eES9ZPRVmdwbQEeGJkajUAD8Vh/IWLrTUk4L/Cy
         5cd3LcL+aW7vCPA5GFbHr0fE5KRzR0BC+4pPewmxkWAjWy/avOiiNlsW8a/pX83V8aX4
         ZhWfNuturOXTGb84nkGARlBhkWbtv0utEE5tFIRu4VYNF6gt3zLV2WOxLSNPu9shKa5M
         GpX65GNxEG5dmUzbInhJAakxa49ZhYgqOVOQQx0cBF0fj9/vpMt78J+Lv2fOlQR0l68c
         ftpw==
X-Gm-Message-State: AOAM53368WUx6wVmb/Kza43wy1N+y4OlV0CbWVwllNNghi0aGMurtQQP
        02mOVwB6JrXTPE9paXIFoFgu0EuUFK4OcXSiel8=
X-Google-Smtp-Source: ABdhPJySDaf/pbiDKUi3FETakILBaatphdNq6Pj8TmFJlHxjNXU60qGeOPF9QUyKHe8vJ9nk0r3xkg==
X-Received: by 2002:a05:6214:1ccf:b0:461:b48b:29e4 with SMTP id g15-20020a0562141ccf00b00461b48b29e4mr99131518qvd.5.1655124602654;
        Mon, 13 Jun 2022 05:50:02 -0700 (PDT)
Received: from [127.0.1.1] ([8.46.76.77])
        by smtp.gmail.com with ESMTPSA id c10-20020a05622a024a00b0030509143423sm4933313qtx.69.2022.06.13.05.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 05:50:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com, dylany@fb.com
Cc:     Kernel-team@fb.com
In-Reply-To: <20220613101157.3687-1-dylany@fb.com>
References: <20220613101157.3687-1-dylany@fb.com>
Subject: Re: [PATCH 0/3] io_uring: fixes for provided buffer ring
Message-Id: <165512459373.12400.11120014654091283779.b4-ty@kernel.dk>
Date:   Mon, 13 Jun 2022 06:49:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 13 Jun 2022 03:11:54 -0700, Dylan Yudaken wrote:
> This fixes two problems in the new provided buffer ring feature. One
> is a simple arithmetic bug (I think this came out from a refactor).
> The other is due to type differences between head & tail, which causes
> it to sometimes reuse an old buffer incorrectly.
> 
> Patch 1&2 fix bugs
> Patch 3 limits the size of the ring as it's not
> possible to address more entries with 16 bit head/tail
> 
> [...]

Applied, thanks!

[1/3] io_uring: fix index calculation
      commit: 97da4a537924d87e2261773f3ac9365abb191fc9
[2/3] io_uring: fix types in provided buffer ring
      commit: c6e9fa5c0ab811f4bec36a96337f4b1bb77d142c
[3/3] io_uring: limit size of provided buffer ring
      commit: f9437ac0f851cea2374d53594f52fbbefdd977bd

Best regards,
-- 
Jens Axboe


