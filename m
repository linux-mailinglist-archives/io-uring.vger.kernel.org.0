Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152C81C00EE
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2020 17:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgD3P4p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Apr 2020 11:56:45 -0400
Received: from static-213-198-238-194.adsl.eunet.rs ([213.198.238.194]:44178
        "EHLO fx.arvanta.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgD3P4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Apr 2020 11:56:45 -0400
Received: from arya.arvanta.net (arya.arvanta.net [10.5.1.6])
        by fx.arvanta.net (Postfix) with ESMTP id C3E323829;
        Thu, 30 Apr 2020 17:56:43 +0200 (CEST)
Date:   Thu, 30 Apr 2020 17:56:43 +0200
From:   Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org
Subject: Re: Build 0.6 version fail on musl libc
Message-ID: <20200430155643.GA11928@arya.arvanta.net>
References: <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
 <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
 <20200429193315.GA31807@arya.arvanta.net>
 <4f9df512-75a6-e4ca-4f06-21857ac44afb@kernel.dk>
 <20200429200158.GA3515@arya.arvanta.net>
 <962a1063-7986-fba9-f64e-05f6770763bc@kernel.dk>
 <20200429203844.GA25859@arya.arvanta.net>
 <bcfe40db-ebcd-df5c-ca18-4a867c9d1e1e@kernel.dk>
 <20200430143836.GA4948@arya.arvanta.net>
 <2e8edb98-0594-8e77-012f-4e96139878fb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e8edb98-0594-8e77-012f-4e96139878fb@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 2020-04-30 at 08:47, Jens Axboe wrote:
> On 4/30/20 8:38 AM, Milan P. Stanić wrote:
[...]

> > Maybe you would consider changes in make to have separate invocation for
> > make (just build lib), make test and make examples. Will be easier for
> > distribution maintainers.
> 
> Sure, I'd be fine with that, as long as 'all' or default still builds
> the whole thing.

Nice, and thanks for accepting suggestion.

-- 
regards
