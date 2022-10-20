Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE95606286
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 16:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJTOLJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 10:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiJTOLI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 10:11:08 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CFF1413B6
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 07:11:03 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y8so20334659pfp.13
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 07:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOrCF2hAhKFGZ9V2xOY1JROh4gvBzmt22XBEKQJlFc4=;
        b=XnKraDeamBqlVhEG57HyuqYYkPmrnopXfvjpfP/Sz7wqahpTNpgLzy9qgnomYGCuD0
         FRwJd6kWrb1KZp17lvl4NM9281It6DMWhztAYKFZS8X/ZIVtFUsrhLkd27J4zTqf8a78
         aVe6RvwjXwYl62Kji9TO/5x+W10aTmABtmJ3ar9eoVTyQbOI0JLLOMyoCgp2EoiqlZu9
         /jn1sxELa3NQ50bYFCNAVFsQgJ64QmcLcyXvCarm8smOH41rZr5uPiCxQpmKfVTjYWYG
         S5ZeyrwjvTx3E5y+FVqfyBZDFyq7zKgWq/MuaaTqqSGT1TW3Uk+b2Di7FBCHfabCGi5i
         J/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOrCF2hAhKFGZ9V2xOY1JROh4gvBzmt22XBEKQJlFc4=;
        b=YRRVOeNXA8Lou5dIcQD/hrurhROVGG9w2XN/iqn/QdhISA2b/dEC8Onrh2FwrTCC3b
         8iZtcIWoeeAPl6+FstO+ZkTyVeuePlK0yZVZkjwe9Q7P9Kh0pZjUOwBpFMsKGskDDQqd
         zbdGdXjHImUSxkjM+wFPbzMf9HBA/xlNcDkpFpa4ofAG9BnoXAAKbvIuCqLGgtJjdwdu
         v5qMdFIuu4HNY3fhmUSJ6boWOK90usgf/Q5ZlTis4RhgXSSKzPqYGHR4ZmjtWx9gRi4q
         C1YaJOl6XMG78zWUMLQ8Hpm4P+L8Z+IoERAAz4XeoL2Zi6OW5QVGOFUBlNe8Jd/Zk6H4
         3ERQ==
X-Gm-Message-State: ACrzQf0d8RC5f60loq6BiGwqZZFBJ93BVShOwk1PaCstomydmk1SGtBO
        r6kM0bClo9Oiug0Pd6WrS7ycRGMZ9kIku2Hx
X-Google-Smtp-Source: AMsMyM7sy7rHSilMlp/qjhoA4tW02sOJnAj1uxu5/jwx9gIU16oSvQMj15aaxHSJS3jelcCDqqP4KQ==
X-Received: by 2002:a63:f924:0:b0:46b:1a7d:3b91 with SMTP id h36-20020a63f924000000b0046b1a7d3b91mr12152688pgi.133.1666275063221;
        Thu, 20 Oct 2022 07:11:03 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id f18-20020a170902ce9200b00179eb1576bbsm12481529plg.190.2022.10.20.07.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 07:11:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Dylan Yudaken <dylany@meta.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>
In-Reply-To: <20221020131118.13828-1-ammar.faizi@intel.com>
References: <20221020131118.13828-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v2 0/3] Clean up clang `-Wshorten-64-to-32` warnings
Message-Id: <166627506217.167739.6624404748025563028.b4-ty@kernel.dk>
Date:   Thu, 20 Oct 2022 07:11:02 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 20 Oct 2022 20:14:52 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This is a v2.
> 
> v2:
>   - Fix Signed-off-by tag.
>   - Make the cast in patch #1 consistent.
> 
> [...]

Applied, thanks!

[1/3] liburing: Clean up `-Wshorten-64-to-32` warnings from clang
      commit: b9df4750ce9335437a34fd93c76863d871b70416
[2/3] Makefile: Introduce `LIBURING_CFLAGS` variable
      commit: 1755faf1737d0d84775aa46dd0a2b4b2e3474d28
[3/3] github: Append `-Wshorten-64-to-32` flag for clang build
      commit: 80817b7cd56b96a095c3cb4583a357d16fb867f1

Best regards,
-- 
Jens Axboe


