Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78D85FAA86
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 04:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJKCQN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 22:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJKCQL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 22:16:11 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAB97F26C;
        Mon, 10 Oct 2022 19:16:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j16so19425636wrh.5;
        Mon, 10 Oct 2022 19:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AKmn1ZqJg6n6NOpGfuSCZ3TspYFQYAD5wJVDDfMRloA=;
        b=Fx2L+XX6fSi7CB6Ikg74Y0UELagcKYSfOpf4lHNhaCApvpelxtxGz0QbMoS02Ok6+W
         1xbLw3mWqJlWwPhf5fb4QYZpoNfB4c2+P+5cE84R+Q5YXRKkCxGi9xKoTE7dUCymyey3
         7wBL5ZwaY2zpT/w0GGkcyeip/1iMxUo563/ect2Bjajo37bsmD2A9/84qzHq85lol9LQ
         BCix1f62web43R4ACIKnl8HgdxkpCH9OwTO/okF3oJAHyXgOAV/0QQwXz5VwZ1OnGZ+0
         SHyM5zlmU7dbx9X8pPL7zOO6zdvb4KgtE+7i7gH+ptxpmdMQsJYcNeKc6Xgq8cwnIabo
         ngEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKmn1ZqJg6n6NOpGfuSCZ3TspYFQYAD5wJVDDfMRloA=;
        b=wgW2VaPZpaj+LV156mQAmYjLWzbDDnxI0uml1RTwZex60KQablovjtYXjetOSQhHQr
         uC/MDAmshLDbvdzro9/38pLq8eyzl1AGqqEBTDnfyG5Vps1PnSbHehTZsrzLde6DOmuj
         E7c6GcEkHFTHQxV830v3wrumM6Qfjg1m+bnM6LvB53ZvTeVCPLP+E4wmiXC561URKXKh
         jMjCAQVnPtn3j4Pcaz3zRoddR/soa3VZu05G2FmFQi6fx2WzK4opZFc9JR1kuafA25ch
         AWEiWUJ86JqiQ3wtv/7xgeHUtaO7uHCxe+zj+ov4XTKclSAP2PBA5Jp132zMZgtxg9wZ
         YxaQ==
X-Gm-Message-State: ACrzQf3OGke3G/dEF5PCvJA5Hp0ilmAuyENiSz/hNIOf1CZlRom0HMBJ
        /5OCJr1WxzTfIj2UyR/JOAHeL2+6fEg=
X-Google-Smtp-Source: AMsMyM6zu1TESEPTphf3dMkx5VZnWEcFg6yd8j+YboG4dL766QgDDPhcr6uWxp4Jr8zrAv4lFQltsw==
X-Received: by 2002:a5d:47aa:0:b0:22e:3ed6:77a8 with SMTP id 10-20020a5d47aa000000b0022e3ed677a8mr13295837wrb.648.1665454565535;
        Mon, 10 Oct 2022 19:16:05 -0700 (PDT)
Received: from [192.168.8.100] (94.196.221.180.threembb.co.uk. [94.196.221.180])
        by smtp.gmail.com with ESMTPSA id j38-20020a05600c1c2600b003b3365b38f9sm11357921wms.10.2022.10.10.19.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 19:16:04 -0700 (PDT)
Message-ID: <db66c011-4b86-1167-f1e0-9308c7e6eb71@gmail.com>
Date:   Tue, 11 Oct 2022 03:10:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [regression, v6.0-rc0, io-uring?] filesystem freeze hangs on
 sb_wait_write()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20221010050319.GC2703033@dread.disaster.area>
 <20221011004025.GE2703033@dread.disaster.area>
 <8e45c8ee-fe38-75a9-04f4-cfa2d54baf88@gmail.com>
 <697611c3-04b0-e8ea-d43d-d05b7c334814@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <697611c3-04b0-e8ea-d43d-d05b7c334814@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/22 03:01, Jens Axboe wrote:
> On 10/10/22 7:10 PM, Pavel Begunkov wrote:
>> On 10/11/22 01:40, Dave Chinner wrote:
>> [...]
>>> I note that there are changes to the the io_uring IO path and write
>>> IO end accounting in the io_uring stack that was merged, and there
>>> was no doubt about the success/failure of the reproducer at each
>>> step. Hence I think the bisect is good, and the problem is someone
>>> in the io-uring changes.
>>>
>>> Jens, over to you.
>>>
>>> The reproducer - generic/068 - is 100% reliable here, io_uring is
>>> being exercised by fsstress in the background whilst the filesystem
>>> is being frozen and thawed repeatedly. Some path in the io-uring
>>> code has an unbalanced sb_start_write()/sb_end_write() pair by the
>>> look of it....
>>
>> A quick guess, it's probably
>>
>> b000145e99078 ("io_uring/rw: defer fsnotify calls to task context")
>>
>>  From a quick look, it removes  kiocb_end_write() -> sb_end_write()
>> from kiocb_done(), which is a kind of buffered rw completion path.
> 
> Yeah, I'll take a look.
> Didn't get the original email, only Pavel's reply?

Forwarded.

Not tested, but should be sth like below. Apart of obvious cases
like __io_complete_rw_common() we should also keep in mind
when we don't complete the request but ask for reissue with
REQ_F_REISSUE, that's for the first hunk


diff --git a/io_uring/rw.c b/io_uring/rw.c
index a25cd44cd415..f991aa78803e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -239,6 +239,18 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
  	if (unlikely(res != req->cqe.res)) {
  		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
  		    io_rw_should_reissue(req)) {
+			struct io_rw *io = io_kiocb_to_cmd(req, struct io_rw);
+
+			/*
+			 * Need to do it for each rw retry, do it here instead
+			 * of handling it together with REQ_F_REISSUE
+			 */
+			if (io->kiocb.ki_flags & IOCB_WRITE) {
+				kiocb_end_write(req);
+				fsnotify_modify(req->file);
+			} else {
+				fsnotify_access(req->file);
+			}
  			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
  			return true;
  		}
@@ -317,6 +329,12 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
  		req->file->f_pos = rw->kiocb.ki_pos;
  	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
  		if (!__io_complete_rw_common(req, ret)) {
+			if (rw->kiocb.ki_flags & IOCB_WRITE) {
+				kiocb_end_write(req);
+				fsnotify_modify(req->file);
+			} else {
+				fsnotify_access(req->file);
+			}
  			io_req_set_res(req, final_ret,
  				       io_put_kbuf(req, issue_flags));
  			return IOU_OK;

