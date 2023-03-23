Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F396C7112
	for <lists+io-uring@lfdr.de>; Thu, 23 Mar 2023 20:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjCWTbN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Mar 2023 15:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjCWTbL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Mar 2023 15:31:11 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D835AF0A
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 12:31:08 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id p17so8717378ioj.10
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 12:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679599867;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5qL7YDqEjZS17rslYpUABTleMQOXUmjQh7IRgy/c0vQ=;
        b=Itfmanb9KQeJZNor4J8N39ysEYZev+ae+1YbwzuClv3rjLJ2WCJNPZFbtNVu7I41h1
         YLClFZetcshjkCG3EkpW0zP3IgycDwYcNjibbojyhXuOfR171bvsm+WhtQvHxxye3m3v
         1/EQ0wZcc2VrgYMYzqDY69O7Qsq/5r+MzNDBr5c5bEETXNUlvrCJI2cz8zcKkc5s/cYG
         KAmAFOrWRCwvxpYD6/otcJZE68Wgfda6xQ/dYDHnUFsuExw4fvWk3JtpjRwvvpeZ1Q8+
         V/8+LnPNffFMdc4oqhTnqC/Idg7VXm0K6mhk8T5PPhplqG83sXN0BOZvDlBGfKSCnNXH
         h5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679599867;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5qL7YDqEjZS17rslYpUABTleMQOXUmjQh7IRgy/c0vQ=;
        b=luiRoJYv56lNQSfOH5oKkIj1BYx1PtYh9yvNsttvrdRJqScllh9APQMci+bUMFhrl/
         Y8Vowx7e+qIVV6qExXA919xa+6IOlqgCFmD9wPTxueAqFpElwZl5FXHIuSYhroi6a/GX
         b/y3KLjeaSo+G5ZBMO7snQ2B8GDtX0cmAiuCO7ul/gG8ZgZe+IdbkxBr4da3qDXaupAl
         BeqJ/iWwRh0a40RTrMaY6Ni/flDupAizPUIuqrnBAKet0Z4zc98jRHXvcPdqRVfITdd7
         UJ+UvQDdc1/WnFwCU6W38by3l/XnH+6Hs549ESi+hXc+EQQC1mlM8y6ZHFaMAzrM0qHT
         6xNw==
X-Gm-Message-State: AO0yUKW0t5EJyAu4WQWH5ynveqHJht8FL2s9jRHOt5VyBWeW7pjDK0HL
        DbYydHRFGWGdsGP5WAugaPQlgpsb7oUgXkKQ1TBnFQ==
X-Google-Smtp-Source: AK7set/wVco0STItuAeFW82sAHqvyGu/eVGE+9mRwlmd4QpKkJPmtHWzHUnFaY5NYwpmgqN7F7nEIQ==
X-Received: by 2002:a05:6602:3793:b0:758:5405:7275 with SMTP id be19-20020a056602379300b0075854057275mr218835iob.2.1679599867660;
        Thu, 23 Mar 2023 12:31:07 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q1-20020a02b041000000b004061d6abcd2sm6143454jah.146.2023.03.23.12.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 12:31:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230322011628.23359-1-krisman@suse.de>
References: <20230322011628.23359-1-krisman@suse.de>
Subject: Re: [PATCH 0/2] io-wq: cleanup io_wq and io_wqe
Message-Id: <167959986716.282244.18303359938879065566.b4-ty@kernel.dk>
Date:   Thu, 23 Mar 2023 13:31:07 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 21 Mar 2023 22:16:26 -0300, Gabriel Krisman Bertazi wrote:
> This tides up the io-wq internal interface by dropping the io_wqe/io_wq
> separation, which no longer makes sense since commit
> 0654b05e7e65 ("io_uring: One wqe per wq").  We currently have a single
> io_wqe instance per io_wq, which is embedded in the structure.  This
> patchset merges the two, dropping bit of code to go from one to the
> other in the io-wq implementation.
> 
> [...]

Applied, thanks!

[1/2] io-wq: Move wq accounting to io_wq
      commit: 98bab464dbc90c0f0495bcf9bc6e2d5a30da192d
[2/2] io-wq: Drop struct io_wqe
      commit: 98bab464dbc90c0f0495bcf9bc6e2d5a30da192d

Best regards,
-- 
Jens Axboe



