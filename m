Return-Path: <io-uring+bounces-1585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 416678AA1EB
	for <lists+io-uring@lfdr.de>; Thu, 18 Apr 2024 20:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4706B238CE
	for <lists+io-uring@lfdr.de>; Thu, 18 Apr 2024 18:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47546174EF9;
	Thu, 18 Apr 2024 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFUydNOC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BB316FF48
	for <io-uring@vger.kernel.org>; Thu, 18 Apr 2024 18:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713464244; cv=none; b=PI6jQBZBANsi52+9hMh3R1fmofxMB1c1PWDl479+fZLHZ8JBVdWe1fKBDjV+67R8dmINjSd8I51ZkjXx/46ggqnOuzZxS3GW4vzkxysEAVVM4OyVT24VwYrkChvOZHRPU7DEpcHDMI29HjdgiJmGlg0mv2DEjVSAYJlDpbtT6zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713464244; c=relaxed/simple;
	bh=vmvbVo8iX63SlO/Ic14Z7CqMFz4M3AiUoEU3eNFUoSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXlVcVshDyJ6fCkl5/sUptxtDBZxGgvG/CF83pWj+k4u1p7UVxRlZvXueDrEBMUw1j0T4t1ffYB/YS/WYJl5DTQWlglwi/XgWsvnbwGKSlPNdkdFz2HL5qHqefhqLcsCca56lwWsYxHUnPX7ABYEgNkY+fswyJey8lEivZL6faI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFUydNOC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7366BC113CC;
	Thu, 18 Apr 2024 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713464243;
	bh=vmvbVo8iX63SlO/Ic14Z7CqMFz4M3AiUoEU3eNFUoSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cFUydNOCAtV6XKRgnTRbwLP+8NQujtn8cySOeemJK1lkW88+MeWgCOLhVm+Sg7zTh
	 13OXacSJSNUl1UO6pTt10AGkRm9Wuu0kDbIR7Iuhid0VDCN1m65OLTaWnhENaPDyn1
	 uB7cydrPokVi35iAxoLZJmeLvcGosbkkwwWMjuE1rNlHnbXisbYldBBi1YzcPXPO1x
	 ueFAUx2RaUXuB2NrfTLe02ZF9AO0ZrDG40MiRSzeMCO2sqX76uZ5+5Haj/9avkoSid
	 cS/CsdreHHuAtiiFA9KQH+k/V5v9gh8EzVoEOipkjPqjM4uN54qJpoOyQASjSjvhIz
	 n5/XI+GncWyPA==
Date: Thu, 18 Apr 2024 12:17:20 -0600
From: Keith Busch <kbusch@kernel.org>
To: Doug.Coatney@microchip.com
Cc: io-uring@vger.kernel.org
Subject: Re: VU NVMe commadns with io_uring? NVME_URING_CMD_IO
Message-ID: <ZiFjsICii8guw5rP@kbusch-mbp>
References: <DM8PR11MB5717EA70F88545314961D862810E2@DM8PR11MB5717.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5717EA70F88545314961D862810E2@DM8PR11MB5717.namprd11.prod.outlook.com>

On Thu, Apr 18, 2024 at 05:24:15PM +0000, Doug.Coatney@microchip.com wrote:
> HI Folks!
> 
> Trying to send down some vendor unique NVMe commands with io_uring and fixed buffers via NVME_URING_CMD_IO. 
> 
> I have no issues sending standard NVMe read/write requests, but we are working on some VU commands which have
> buffer and length in different command payload offsets. So I'm trying to find where io_uring populates the NVMe cmd 
> payload for a "write" (outbound) or "read" inbound request. 
> 
> This percolates into drivers/nvme/host/ioctl.c: nvme_uring_cmd_io() as expected where io_uring_cmd points to the 
> expected cmd payload and a local struct nvme_command is created to be encoded into a user request via 
> nvme_alloc_user_request() call. 
> 
> Within the nvme_alloc_user_request() call nvme_init_request() is called which performs a 
> memcpy(nvme_req(req)->cmd,cmd, sizeof(*cmd));  which is basically copying the local 
> struct nvme_command to the request structure. The issue though is the buffer and length 
> are not populated in the cmd payload at this time. 
>
> Instead this happens somewhere else at I/O processing time which I haven't found yet. 
> I'm trying to track that location down and was wondering if I'm on the right path here or not. 

Right after nvme_init_request(), the data payload is attached to the
struct request in nvme_map_user_request(), which works for both fixed
and unregistered buffers.

The payload gets attached to the nvme command later after dispatching
the request through the block layer. Assuming your nvme is PCI, that
happens in nvme_map_data().

> Any suggestions on where this update occurs would be incredibly useful. Also we're hoping 
> to have multiple fixed buffers for a specific command specified within the cmd payload 
> In order to provide for extended key data on the commands. Essentially providing KV support 
> for store/retrieve of keys larger than what can fit in the command payload. 
> 
> We're on a path to use fixed buffers and to be able to map them on demand for the VU 
> commands, but inserting them into the command payload is the missing point at present. 

