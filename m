Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372F65606E4
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 19:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiF2RCy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 13:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiF2RCx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:02:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5166A396A8
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:02:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so1764pjm.4
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=BHAoPe0LtGeBm56spoDS3yathzl90N03aGmvftJuG74=;
        b=i+hxx/4a1CN8uu8u+ykSN436MdydDVXYbrdj9qhLscIlc2drRbKDbKdbHWx6ReoMyX
         HT2lh3Ca9BJRdp+hXlmRc2nlBhopomIqIFswR4fgQvb2WEiA9Juk8MQarntTTm+wxpAy
         3+Rw1tEpaH8y3krnI0OupWKwOs3G9k1P50b/tJZMauGyP8N8gzpWXTa6swEZw36hBbmT
         ufuLyaYQHvjgzvOLqPbXemEDFkWr2+wQnCY9f76GOI/tcQuBf0O9lt5xipvEnTOTtfhB
         kizWtouCgFWZupnpzbgSo9Mo4nHWUJ3QIQ2d3MWA1sEGlUPaNbgNbKvf6cvPO2exsEzP
         Whuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=BHAoPe0LtGeBm56spoDS3yathzl90N03aGmvftJuG74=;
        b=R/FE9hjP6jMaeQ1NSOG2cdN3eF5RHCwWBMdN3Unf/b9eysCu1Q/empmxx7xIAsPKrR
         DV7AsMNKwkMKSZOxCHSbrwrAmL6Ufm8eGGjGWU4krjOS8m72m7Pibxc6sBBkYmWJ6dNL
         Ovdk0KlxhXdq6Fr9Y2xl8fEPXtUfczqrg76U7PdI1wXmvuVA07FtZjMua4+TTZ6TiYCF
         RFLxm7+n3NVSPu+6z4lef0lYC9F5+qWJGPWgdYiJwGXarUP7YK5TstAkzJlEiY6Uo2XW
         J79UhEamfMN710niyTk9JgNzv4tb/pz+orBW62EHcf7SdLYnc7kKsHem2Q0w9LPPgPZy
         yYKQ==
X-Gm-Message-State: AJIora+56QE4I53/gbIJdoarhfTeUlC4MqUCXPTK7FnxQDMxe2G2npUP
        Vx97Q6FrQEk9OntB30/nNTgAG4vr0h7apA==
X-Google-Smtp-Source: AGRyM1sWVrUQIACZlc7Ih5E062kHZqh6LEO+Fk6KS7uhY8elnZCqYmk3zV6KH5duQDJUeakmulqTBA==
X-Received: by 2002:a17:902:6b0b:b0:16a:5c43:9aa6 with SMTP id o11-20020a1709026b0b00b0016a5c439aa6mr10053253plk.91.1656522172726;
        Wed, 29 Jun 2022 10:02:52 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d21-20020a17090abf9500b001ec9b7efec2sm2457872pjs.5.2022.06.29.10.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:02:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
References: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: let to set a range for file slot allocation
Message-Id: <165652217207.178381.2256200904348268110.b4-ty@kernel.dk>
Date:   Wed, 29 Jun 2022 11:02:52 -0600
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

On Sat, 25 Jun 2022 11:55:38 +0100, Pavel Begunkov wrote:
> From recently io_uring provides an option to allocate a file index for
> operation registering fixed files. However, it's utterly unusable with
> mixed approaches when for a part of files the userspace knows better
> where to place it, as it may race and users don't have any sane way to
> pick a slot and hoping it will not be taken.
> 
> Let the userspace to register a range of fixed file slots in which the
> auto-allocation happens. The use case is splittting the fixed table in
> two parts, where on of them is used for auto-allocation and another for
> slot-specified operations.
> 
> [...]

Applied, thanks!

[1/1] io_uring: let to set a range for file slot allocation
      commit: 864a15ca4f196184e3f44d72efc1782a7017cbbd

Best regards,
-- 
Jens Axboe


