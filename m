Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5F57B929
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 17:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbiGTPHM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 11:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239709AbiGTPHL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 11:07:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C41C237D6
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 08:07:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h8so3818778wrw.1
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 08:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTqfA6srykFLYf4Fjk4hYRBDzM8KBinziURX/lp7iC4=;
        b=73L1dpOo8OCJSAwaeAEqeJ79WIrhe6F2SuOiyRR6pIV7C8PCjo6CI73E4F9kboOKr8
         eBuLuyR90Arl4co8CMy/sdbL0vqDMRWTKOlkwEK8sJDJd48wX5WT9C54DcI4GMGmNSGr
         I7/RFhu88x1cTNzbLP4DXsCYGcGZE29fqkzjM3PvGr51B6KYP9Aa665Msn2B701ONvgA
         /5LgSqIZKZ+otQ6EePf36h1jhhIvnlHDB88LmL6N0Onul01WAiEBK0k1fLpKpTTSQQIl
         F0pnrSw5HnSRwytlBtw1eNUIW/ZEf9WcvtMkOY0913fEX7A7r71GNk/UgPgZ+g+iTk/z
         rBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTqfA6srykFLYf4Fjk4hYRBDzM8KBinziURX/lp7iC4=;
        b=FW0vzUo2KjYZzKfzQ1kaYaqGNxZ7pmcQdvs0YKuln2a9LYw/2iaXo0/GkCKc6buUJF
         5YBGtVrkC15RIPijPu6DTOc77AxHcNjG7MQEaDuy4fVikstK6XuDoigGG6YBFHBKqfXl
         htFt64ILRiJFVsFP5wWfjgPT4hM1kiCSg9WlLYeA6uYcM9mbeRtWe8sx+Px+Xg0SdLS2
         Hw/zMRlt2MB2t7Imeog/MyKUNU8K11DPDml0YKZuMepnpu7Yo5n1N/Wm97msEKrmycNS
         gIs0k59g3zsNQNnahJ0wZxUW3yerQ0nx5pQB0ilT3EPxAd999UfH2bzdBjMtcAJbZpGU
         6qzw==
X-Gm-Message-State: AJIora8OdjCDm0qbo3HcPojWln//Z4rnr+uJi8uwvw8tpWbHHzgC4LbO
        dj2cRTWqtCvw+3te8z983m0c3oGlXnVskfxd3wSZ
X-Google-Smtp-Source: AGRyM1tTO3AXCPrAOBwfVD7lxLpRl/Qu85ZbXMxFT4AVQj9Pz/D2gv4wdnRdcBXnr44Xztt45Wa3aD3BXAzEN2DEOaA=
X-Received: by 2002:adf:fb86:0:b0:21e:3cc8:a917 with SMTP id
 a6-20020adffb86000000b0021e3cc8a917mr6548771wrr.538.1658329628941; Wed, 20
 Jul 2022 08:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220715191622.2310436-1-mcgrof@kernel.org> <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <CAHC9VhRzm=1mh9bZKEdLSG0vet=amQDVpuZk+1shMuXYLV_qoQ@mail.gmail.com>
 <CAHC9VhQm3CBUkVz2OHBmuRi1VDNxvfWs-tFT2UO9LKMbO7YJMg@mail.gmail.com> <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
In-Reply-To: <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 20 Jul 2022 11:06:57 -0400
Message-ID: <CAHC9VhQeScpuhFU=E+Q7Ewyd0Ta-VLA+45zQF9-g-Ae+CN1fgA@mail.gmail.com>
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file op
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 18, 2022 at 1:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 7/15/2022 8:33 PM, Paul Moore wrote:
> > On Fri, Jul 15, 2022 at 3:52 PM Paul Moore <paul@paul-moore.com> wrote:
> >> On Fri, Jul 15, 2022 at 3:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
> >>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> >>>> add infrastructure for uring-cmd"), this extended the struct
> >>>> file_operations to allow a new command which each subsystem can use
> >>>> to enable command passthrough. Add an LSM specific for the command
> >>>> passthrough which enables LSMs to inspect the command details.
> >>>>
> >>>> This was discussed long ago without no clear pointer for something
> >>>> conclusive, so this enables LSMs to at least reject this new file
> >>>> operation.
> >>> From an io_uring perspective, this looks fine to me. It may be easier if
> >>> I take this through my tree due to the moving of the files, or the
> >>> security side can do it but it'd have to then wait for merge window (and
> >>> post io_uring branch merge) to do so. Just let me know. If done outside
> >>> of my tree, feel free to add:
> > I forgot to add this earlier ... let's see how the timing goes, I
> > don't expect the LSM/Smack/SELinux bits to be ready and tested before
> > the merge window opens so I'm guessing this will not be an issue in
> > practice, but thanks for the heads-up.
>
> I have a patch that may or may not be appropriate. I ran the
> liburing tests without (additional) failures, but it looks like
> there isn't anything there testing uring_cmd. Do you have a
> test tucked away somewhere I can use?

I just had a thought, would the io_uring folks be opposed if I
submitted a patch to add a file_operations:uring_cmd for the null
character device?  A simple uring_cmd noop seems to be in keeping with
the null device, and it would make testing the io_uring CMD
functionality much easier as it would not rely on a specific device.

I think something like this would be in keeping with the null driver:

  static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int
issue_flags)
  {
    return 0;
  }

Thoughts?

-- 
paul-moore.com
