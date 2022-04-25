Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7366250E861
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244461AbiDYSlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244459AbiDYSln (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:41:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA97237DF
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:38:37 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 125so16836514iov.10
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=8rifsCv69nw69I4GK+bCshQc/cldrT0s0BDup/p3lDA=;
        b=snebphsNQtpdq/ohNXnGeiRMsil3rcL47KdegCFOuFFfqsYZ43enuZoTv8QYh/Gr79
         VjZHHuYjoJHLOn/guoImYrvAhuhzdMj48CPXAg64TLLn7e8WZviQUBLA7nyedjcnV4q9
         ZVK3ZoSKlxicdRzBkF+sCSnXD5qh2KInb40cg5JrWR+h5FkgVXdvkRdtoH/q1bQgP8hy
         HYwJnKMXRTBNmsw509oivV8jtXU300TdWvwb/UnBeQT0yK8U/VI2clJ3Bp2W8qRhaYtD
         45CRu111aeveRXFccPNe3cHglRjiiL2EtwzzfwrqggZLhfU5d1LE4Guyz7l/VZpnWWxb
         ATYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=8rifsCv69nw69I4GK+bCshQc/cldrT0s0BDup/p3lDA=;
        b=tTAe8q/msb2nZEYIV1umspU6qhZUNo7unljz1I0+LKD72nZpS3BS++mjyMPOI6GZcz
         6QNTpaTBOeMoDnp0ma52PC7+IRDdjIlsX8hog+jhxdloEwmmbQXG8D2TSHA9IsV7+QO7
         TTL8VBETH/V3vY9EjBwgShyRWSfmSt5KB6OQ5XRqz6321YwPxy8mO6DYs9LQbrsqL2gL
         LSRol1LAKRzNLIPJ4AjRUn4Lq5oSba27AoeT2Yl5f/ZYS9P3KsZLzIRExJVnULrtkWV7
         w8J/Vpl1J8RFROGnyqiK1eAO+B1Ul54RnsfaYmOyFlaDhQ4r9SSdX0aHm/+XdYZWHB8s
         NWdg==
X-Gm-Message-State: AOAM5309PFrrrStcWjMiampbWI4Bf7uX+6Gc8DtDpCv2nK5k1X2FwSol
        wuvJuIAwllfrmi7xxW0yYQymzw==
X-Google-Smtp-Source: ABdhPJxtf54grF47OAFHtwhuSFVj0W3OCtRnFivuE8zvEVlrgD8vXDtiUevVPhD71wB+oVHrR4s5qQ==
X-Received: by 2002:a05:6638:130d:b0:32a:e3da:92d0 with SMTP id r13-20020a056638130d00b0032ae3da92d0mr3523801jad.141.1650911917291;
        Mon, 25 Apr 2022 11:38:37 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x5-20020a6bfe05000000b006572a49d97fsm8132234ioh.49.2022.04.25.11.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 11:38:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, kernel-team@fb.com, shr@fb.com,
        linux-nvme@lists.infradead.org
Cc:     joshi.k@samsung.com
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
References: <20220425182530.2442911-1-shr@fb.com>
Subject: Re: [PATCH v3 00/12] add large CQE support for io-uring
Message-Id: <165091191658.1541118.14572706023286710745.b4-ty@kernel.dk>
Date:   Mon, 25 Apr 2022 12:38:36 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 25 Apr 2022 11:25:18 -0700, Stefan Roesch wrote:
> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
> To support the longer CQE's the allocation part is changed and when the CQE is
> accessed.
> 
> The allocation of the large CQE's is twice as big, so the allocation size is
> doubled. The ring size calculation needs to take this into account.
> 
> [...]

Applied, thanks!

[01/12] io_uring: support CQE32 in io_uring_cqe
        commit: fd5bd0a6ce17d29a41a05e1a90e0bf9589afcc61
[02/12] io_uring: wire up inline completion path for CQE32
        commit: f867ab4b4ff36109c62e2babcbbfb28937409d3a
[03/12] io_uring: change ring size calculation for CQE32
        commit: 279480550322febcceeecc3ca655fb04f3783c43
[04/12] io_uring: add CQE32 setup processing
        commit: 823d4b0ba7cd3c3fa3c3f2578517cf6ec1cbd932
[05/12] io_uring: add CQE32 completion processing
        commit: e9ba19e1015db1f874d15b3cc6d96a4b0420e647
[06/12] io_uring: modify io_get_cqe for CQE32
        commit: e2caab09ddfc573fd89fa77a5963577f6c7331d8
[07/12] io_uring: flush completions for CQE32
        commit: 0f5ddaf0afb7ca17d645ddba4ad866ce845028a3
[08/12] io_uring: overflow processing for CQE32
        commit: e440146360bac2740298c46e1d26802a8006d18f
[09/12] io_uring: add tracing for additional CQE32 fields
        commit: 0db691c0a5959c1e412d9237449c56b345777e57
[10/12] io_uring: support CQE32 in /proc info
        commit: 3b5a857e9998e18d970496b8989cd73c8214bb57
[11/12] io_uring: enable CQE32
        commit: 3b27f0e387239593c3074f8f9bcefea05b25ab7e
[12/12] io_uring: support CQE32 for nop operation
        commit: c5eb9a698f2a082cdfbfdc0b32ed8d855bc6040e

Best regards,
-- 
Jens Axboe


