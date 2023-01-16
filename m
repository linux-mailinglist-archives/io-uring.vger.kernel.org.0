Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8485166BC34
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 11:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjAPKwx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 05:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjAPKwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 05:52:51 -0500
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85205193CC;
        Mon, 16 Jan 2023 02:52:49 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id s3so2004277edd.4;
        Mon, 16 Jan 2023 02:52:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2Y8Hyy1qGfYvpvlZgj3RwxUf0h6wITV/LjTSjDumDI=;
        b=5FqrJjskZ6z0QaRByn0dHgng5hWK2awZPVWTLSYEGSoA0Pyh1fHGk6c8QPKnsAp26Y
         xXiIO/riSD7e8lujZzAMGXZONBD+BNrZGHseGaY8/vYyZbJeEpbgcjCz4tYNGR683m19
         /x3dJh5eTBaq/khcqz/7HknPCEbSOX0TlVSpSm3q394uvDSYaIMqmCduU8smcuod0NUX
         68IGH+RqgeeLH6gVhzvAt/ENnWHKLzgcIPob2jmxYi7tamX5FCyTpErj2vo7eIDzl2+M
         4Q+tWWxW4+jvqnB5Bj5HIyB1E64BgPL5hc5wCeKr/fvyOoTVFgFzutXGmGj7EQ7JF1Zn
         jnLg==
X-Gm-Message-State: AFqh2kqagJVBn6cpBsn/rRoIE5nD8S7bIRsNqvXUM1jQMhfvRcnhwcni
        J7qMMbsbPfHOBuA13uUEgMtHafc/kQ0=
X-Google-Smtp-Source: AMrXdXsKbVA8vmRa9R2GRSxZDjwrvyAjmL52C3/ZHXRdVAjDgUPvB5HXUnjtKtC3ZgfoMxWtPY5QVw==
X-Received: by 2002:a05:6402:371b:b0:48e:c0c3:796f with SMTP id ek27-20020a056402371b00b0048ec0c3796fmr42629082edb.28.1673866368032;
        Mon, 16 Jan 2023 02:52:48 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-006.fbsv.net. [2a03:2880:31ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id j2-20020aa7de82000000b004972644b19fsm11069955edv.16.2023.01.16.02.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 02:52:47 -0800 (PST)
Date:   Mon, 16 Jan 2023 02:52:41 -0800
From:   Breno Leitao <leitao@debian.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     asml.silence@gmail.com, dylany@meta.com, axboe@kernel.dk,
        io-uring@vger.kernel.org, leit@fb.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring: Split io_issue_def struct
Message-ID: <Y8UseW5sTqu72M2U@gmail.com>
References: <20230112144411.2624698-1-leitao@debian.org>
 <20230112144411.2624698-2-leitao@debian.org>
 <87v8lbcwz9.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8lbcwz9.fsf@suse.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 12, 2023 at 05:35:22PM -0300, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
> > This patch removes some "cold" fields from `struct io_issue_def`.
> >
> > The plan is to keep only highly used fields into `struct io_issue_def`, so,
> > it may be hot in the cache. The hot fields are basically all the bitfields
> > and the callback functions for .issue and .prep.
> >
> > The other less frequently used fields are now located in a secondary and
> > cold struct, called `io_cold_def`.
> >
> > This is the size for the structs:
> >
> > Before: io_issue_def = 56 bytes
> > After: io_issue_def = 24 bytes; io_cold_def = 40 bytes
> 
> Does this change have an observable impact in run time? Did it show
> a significant decrease of dcache misses?

I haven't tested it. I expect it might be hard to came up with such test.

A possible test might be running io_uring heavy tests, while adding
enough memory pressure. Doing this in two different instant (A/B test),
might be a unpredicable and the error deviation might hide the benefit.
